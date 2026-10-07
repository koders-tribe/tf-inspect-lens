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
