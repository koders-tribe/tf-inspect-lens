# Plans the bootstrap stack against a mocked provider: no AWS calls.

mock_provider "aws" {
  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
    }
  }
}

variables {
  account_id = "111111111111"
  aws_region = "ap-southeast-2"
}

run "default_bucket_name" {
  command = plan

  assert {
    condition     = aws_s3_bucket.state.bucket == "inspect-lens-terraform-state-111111111111-ap-southeast-2"
    error_message = "unexpected default state bucket name"
  }
}

run "override_bucket_name" {
  command = plan

  variables {
    state_bucket_name = "existing-state-bucket"
  }

  assert {
    condition     = aws_s3_bucket.state.bucket == "existing-state-bucket"
    error_message = "state_bucket_name override not applied"
  }
}

run "rejects_bad_account_id" {
  command = plan

  variables {
    account_id = "12345"
  }

  expect_failures = [var.account_id]
}
