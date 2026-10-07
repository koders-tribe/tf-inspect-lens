###############################################################################
# AWS Provider Configuration
###############################################################################

provider "aws" {

  region = var.aws_region

  # null = default credential chain (AWS_PROFILE, exported credentials, SSO).
  profile = var.aws_profile

  # Refuse to plan/apply against any account other than the one in tfvars.
  allowed_account_ids = [var.account_id]

  # Default tags applied automatically to every supported AWS resource
  default_tags {

    tags = {

      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"

    }

  }

}
