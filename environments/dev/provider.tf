###############################################################################
# AWS Provider Configuration
###############################################################################

provider "aws" {

  # AWS Region where the existing S3 bucket is located
  region = var.aws_region

  # AWS CLI profile used for authentication
  profile = var.aws_profile

  # Default tags applied automatically to every supported AWS resource
  default_tags {

    tags = {

      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"

    }

  }

}