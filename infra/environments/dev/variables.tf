###############################################################################
# AWS Region
###############################################################################

variable "aws_region" {
  description = "AWS region (Inspect Lens default is ap-south-1)."
  type        = string
  default     = "ap-south-1"
}

variable "aws_profile" {
  description = "AWS CLI profile. Leave as default if using env vars / SSO."
  type        = string
  default     = "default"
}

variable "project_name" {
  type    = string
  default = "InspectLens"
}

variable "environment" {
  type    = string
  default = "dev"
}

###############################################################################
# Feature flags — keep expensive resources off until you are ready
###############################################################################

variable "enable_network" {
  description = "Create VPC, subnets, and security groups. Required before RDS or EC2."
  type        = bool
  default     = false
}

variable "enable_nat_gateway" {
  type    = bool
  default = false
}

variable "enable_vpc_endpoints" {
  type    = bool
  default = false
}

variable "enable_rds" {
  type    = bool
  default = false
}

variable "enable_ecr" {
  type    = bool
  default = true
}

variable "enable_github_oidc" {
  type    = bool
  default = true
}

variable "create_github_oidc_provider" {
  description = "Set false if this AWS account already has the GitHub OIDC provider."
  type        = bool
  default     = true
}

variable "enable_compute" {
  type    = bool
  default = false
}

variable "enable_alb" {
  type    = bool
  default = false
}

variable "enable_secrets" {
  type    = bool
  default = true
}

###############################################################################
# S3
###############################################################################

variable "bucket_name" {
  description = "App bucket for photos and PDFs. Import if it already exists."
  type        = string
}

variable "cors_allowed_origins" {
  description = "Frontend origins for presigned S3 PUT/GET. Example: https://app.example.com"
  type        = list(string)
  default     = []
}

###############################################################################
# IAM (app static keys)
###############################################################################

variable "iam_user_name" {
  type = string
}

variable "iam_group_name" {
  type = string
}

variable "policy_arns" {
  description = "Extra policies on the app IAM group. Leave empty; the module attaches a scoped S3+SES policy."
  type        = list(string)
  default     = []
}

###############################################################################
# SES
###############################################################################

variable "ses_emails" {
  description = "Mailbox identities to verify. Prefer ses_domain for production."
  type        = list(string)
  default     = []
}

variable "ses_domain" {
  description = "Sending domain, e.g. inspect-lens.example.com. Empty skips domain identity."
  type        = string
  default     = ""
}

variable "ses_route53_zone_id" {
  description = "Optional hosted zone for automatic DKIM CNAMEs."
  type        = string
  default     = ""
}

###############################################################################
# Network / RDS / compute
###############################################################################

variable "existing_vpc_id" {
  description = "Existing VPC to reuse for Inspect Lens."
  type        = string
}

variable "existing_public_subnet_ids" {
  description = "Existing public subnets to reuse."
  type        = list(string)
}

variable "existing_private_subnet_ids" {
  description = "Existing private subnets to reuse."
  type        = list(string)
}

variable "existing_app_security_group_id" {
  description = "Existing EC2/app security group."
  type        = string
}

variable "existing_rds_security_group_id" {
  description = "Existing RDS security group."
  type        = string
}

variable "db_instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "db_name" {
  type    = string
  default = null
}

variable "db_username" {
  type    = string
  default = "postgres"
}

variable "ec2_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "acm_certificate_arn" {
  type    = string
  default = ""
}

variable "ec2_deploy_path" {
  type    = string
  default = "/opt/inspect-lens-be"
}

###############################################################################
# GitHub / ECR
###############################################################################

variable "github_org" {
  type    = string
  default = "koders-tribe"
}

variable "github_repos" {
  description = "GitHub repositories allowed to assume the Inspect Lens GitHub Actions IAM role."
  type        = list(string)

  default = [
    "inspect-lens-be",
    "inspect-image-analyzer"
  ]
}

variable "ecr_repositories" {
  description = "ECR repositories and their repository-specific settings."
  type = map(object({
    image_tag_mutability = string
    scan_on_push         = bool
  }))

  default = {
    inspect-lens-be = {
      image_tag_mutability = "IMMUTABLE"
      scan_on_push         = true
    }

    inspect-image-analyzer = {
      image_tag_mutability = "MUTABLE"
      scan_on_push         = false
    }
  }
}

variable "github_deploy_environments" {
  type    = list(string)
  default = ["staging", "production"]
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "existing_db_identifier" {
  description = "Existing RDS instance to adopt."
  type        = string
}

variable "existing_db_subnet_group_name" {
  description = "Existing RDS subnet group to adopt."
  type        = string
}

variable "db_engine_version" {
  type    = string
  default = "18.3"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_max_allocated_storage" {
  type    = number
  default = 1000
}

variable "db_backup_retention_period" {
  type    = number
  default = 1
}

variable "db_deletion_protection" {
  type    = bool
  default = false
}

variable "existing_ec2_instance_id" {
  description = "Existing EC2 instance to adopt into Terraform."
  type        = string
}

variable "existing_ec2_instance_profile_name" {
  description = "Existing EC2 IAM instance profile to reuse."
  type        = string
}

variable "existing_ec2_security_group_ids" {
  description = "Existing security groups attached to the EC2 instance."
  type        = list(string)
}

variable "existing_ec2_subnet_id" {
  description = "Existing subnet where the EC2 instance is currently running."
  type        = string
}

variable "existing_ec2_ami_id" {
  description = "Existing AMI used by the EC2 instance."
  type        = string
}

variable "existing_ec2_name" {
  description = "Existing EC2 Name tag."
  type        = string
}
