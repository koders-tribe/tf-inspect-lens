# Plans the stack against mocked providers: no AWS credentials or API calls.
# Catches plan-time errors a fresh account hits, e.g. count values that depend
# on attributes unknown until apply. It cannot catch errors only AWS reports
# (malformed policies, unsupported engine versions).

mock_provider "aws" {
  # The real data source renders JSON locally; the mock would return a random
  # string that aws_iam_policy rejects.
  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
    }
  }

  mock_data "aws_availability_zones" {
    defaults = {
      names = ["zone-a", "zone-b", "zone-c"]
    }
  }

  # Policy attachments validate the ARN format; a random mock value fails on
  # apply. This makes the ARN constant across runs.
  mock_resource "aws_iam_policy" {
    defaults = {
      arn = "arn:aws:iam::111111111111:policy/mock-app-policy"
    }
  }
}

mock_provider "random" {}

variables {
  account_id     = "111111111111"
  aws_region     = "ap-southeast-2"
  iam_user_name  = "inspect-lens-test"
  iam_group_name = "inspect-lens-test"
}

run "defaults" {
  command = plan

  assert {
    condition     = local.bucket_name == "inspect-lens-dev-111111111111-ap-southeast-2"
    error_message = "bucket name should be computed from environment, account and region"
  }

  assert {
    condition     = output.iam_user_name == "inspect-lens-test" && output.iam_group_name == "inspect-lens-test"
    error_message = "create_app_iam_user defaults to true: the app IAM user and group must be planned"
  }
}

run "no_app_iam_user" {
  command = plan

  variables {
    create_app_iam_user = false
  }

  assert {
    condition     = output.iam_user_name == null && output.iam_group_name == null
    error_message = "create_app_iam_user = false must not plan an IAM user or group"
  }
}

run "explicit_bucket_name_wins" {
  command = plan

  variables {
    bucket_name = "existing-company-bucket"
  }

  assert {
    condition     = local.bucket_name == "existing-company-bucket"
    error_message = "an explicit bucket_name must not be replaced by the computed name"
  }
}

run "rejects_bad_account_id" {
  command = plan

  variables {
    account_id = "not-an-account"
  }

  expect_failures = [var.account_id]
}

run "ses_domain_with_route53" {
  command = plan

  variables {
    ses_emails          = ["noreply@example.com"]
    ses_domain          = "example.com"
    ses_route53_zone_id = "Z0000000000000"
  }
}

run "full_platform" {
  command = plan

  variables {
    enable_network = true
    enable_rds     = true
    enable_compute = true
    enable_alb     = true
  }

  assert {
    condition     = output.ec2_deploy_path == "/opt/inspect-lens-be"
    error_message = "compute should be enabled"
  }
}

run "compute_without_ecr" {
  command = plan

  variables {
    enable_ecr     = false
    enable_network = true
    enable_compute = true
  }

  assert {
    condition     = output.github_build_role_arn == null
    error_message = "github_oidc needs ECR and should be off"
  }
}

# Mirrors config/personal.tfvars.example with every practice flag on.
run "practice_mode" {
  command = plan

  variables {
    allow_destroy               = true
    secret_recovery_window_days = 0
    create_app_iam_user         = false
    enable_github_oidc          = false
    enable_network              = true
    enable_rds                  = true
    enable_compute              = true
    enable_public_http          = true
    enable_eip                  = true
    ec2_instance_type           = "t3.micro"
    ec2_swap_gb                 = 2
    ec2_root_volume_gb          = 20
    ec2_uploads_volume_gb       = 20
    ses_emails                  = ["me@example.com"]
  }

  assert {
    condition     = output.ses_sender == "me@example.com"
    error_message = "ses_sender should default to the first ses_emails entry"
  }

  assert {
    condition     = output.iam_user_name == null
    error_message = "practice mode has no app IAM user"
  }

  assert {
    condition     = output.app_env.S3_REGION == "ap-southeast-2" && output.app_env.SES_REGION == "ap-southeast-2"
    error_message = "app_env regions should follow aws_region"
  }
}

run "no_uploads_volume" {
  command = plan

  variables {
    enable_network        = true
    enable_compute        = true
    ec2_uploads_volume_gb = 0
    ses_sender            = "noreply@example.com"
  }

  assert {
    condition     = output.ses_sender == "noreply@example.com"
    error_message = "explicit ses_sender should win"
  }
}

# Mocked apply -> apply with create_app_iam_user switched from true to false,
# sharing state (the practice-account path). Mocked IDs/ARNs are random per
# create, so equal values prove those resources were not recreated. Mocks do
# not apply AWS "forces replacement" rules; this covers address/count changes.
run "apply_with_user" {
  command = apply

  variables {
    enable_network = true
    enable_compute = true
    ses_emails     = ["me@example.com", "ops@example.com"]
  }

  assert {
    condition     = output.iam_user_name == "inspect-lens-test" && output.app_policy_arn != null
    error_message = "user and app policy should exist"
  }
}

run "apply_without_user" {
  command = apply

  variables {
    create_app_iam_user = false
    enable_network      = true
    enable_compute      = true
    ses_emails          = ["me@example.com", "ops@example.com"]
  }

  assert {
    condition     = output.iam_user_name == null && output.iam_group_name == null
    error_message = "IAM user and group should be gone"
  }

  # The mocked policy ARN is fixed, so this only shows the policy still exists;
  # its address (aws_iam_policy.app[0]) and name are unchanged by the flag.
  assert {
    condition     = output.app_policy_arn == run.apply_with_user.app_policy_arn
    error_message = "the app policy must be kept"
  }

  assert {
    condition     = output.bucket_arn == run.apply_with_user.bucket_arn
    error_message = "the S3 bucket must not be recreated"
  }

  assert {
    condition     = output.ecr_repository_urls == run.apply_with_user.ecr_repository_urls
    error_message = "ECR repositories must not be recreated"
  }

  assert {
    condition     = output.ses_email_identity_arns == run.apply_with_user.ses_email_identity_arns
    error_message = "SES identities must not be recreated"
  }

  assert {
    condition     = output.ec2_instance_id == run.apply_with_user.ec2_instance_id
    error_message = "the EC2 instance must not be recreated"
  }
}
