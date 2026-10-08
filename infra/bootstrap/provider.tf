provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  # Refuse to run against any other account, whatever credentials are active.
  allowed_account_ids = [var.account_id]

  default_tags {
    tags = {
      Project   = var.project_name
      ManagedBy = "Terraform"
      Stack     = "bootstrap"
    }
  }
}
