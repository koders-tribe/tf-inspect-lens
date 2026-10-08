###############################################################################
# Account / region (set per account in config/<name>.tfvars)
###############################################################################

variable "account_id" {
  description = "AWS account this stack belongs to. The provider refuses any other account."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "account_id must be a 12-digit AWS account ID."
  }
}

variable "aws_region" {
  description = "AWS region for every resource in this stack."
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile. Leave null and use AWS_PROFILE or exported credentials (docs/aws-setup.md)."
  type        = string
  default     = null
}

variable "allow_destroy" {
  description = "Practice accounts: let destroy remove non-empty S3/ECR and skip the RDS final snapshot and deletion protection."
  type        = bool
  default     = false
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

variable "secret_recovery_window_days" {
  description = "Secrets Manager recovery window. 0 lets destroy + re-apply reuse secret names (practice accounts)."
  type        = number
  default     = 30
}

variable "enable_secrets" {
  type    = bool
  default = true
}

###############################################################################
# S3
###############################################################################

variable "bucket_name" {
  description = "App bucket for photos and PDFs. Null means inspect-lens-<environment>-<account_id>-<aws_region>. Set it explicitly for an existing bucket: a different name replaces the bucket."
  type        = string
  default     = null
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

variable "create_app_iam_user" {
  description = "Create the app IAM user and group (static keys in app.env). Set false where an SCP denies iam:CreateGroup (AWS free-plan accounts) or once the API uses the instance role; the scoped S3 + SES policy is still created and attached to the EC2 role."
  type        = bool
  default     = true
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

variable "ses_sender" {
  description = "EMAIL_SENDER for app.env (a verified identity). Null means the first ses_emails entry."
  type        = string
  default     = null
}

###############################################################################
# Network / RDS / compute
###############################################################################

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "db_instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "db_name" {
  type    = string
  default = "inspect_lens"
}

variable "db_username" {
  type    = string
  default = "inspect_lens"
}

variable "ec2_instance_type" {
  type    = string
  default = "t3.small"
}

variable "acm_certificate_arn" {
  type    = string
  default = ""
}

variable "ec2_deploy_path" {
  type    = string
  default = "/opt/inspect-lens-be"
}

variable "ec2_root_volume_gb" {
  type    = number
  default = 40
}

variable "ec2_uploads_volume_gb" {
  description = "Uploads EBS volume size. 0 skips the volume."
  type        = number
  default     = 20
}

variable "ec2_swap_gb" {
  description = "Swap file created on first boot. Useful on t3.micro (1 GiB RAM)."
  type        = number
  default     = 0
}

variable "enable_eip" {
  description = "Elastic IP for the app instance (stable address without an ALB)."
  type        = bool
  default     = false
}

variable "enable_public_http" {
  description = "Practice only: open the app port to 0.0.0.0/0 over plain HTTP, bypassing the ALB."
  type        = bool
  default     = false
}

###############################################################################
# GitHub / ECR
###############################################################################

variable "github_org" {
  type    = string
  default = "koders-tribe"
}

variable "github_repo" {
  type    = string
  default = "inspect-lens-be"
}

variable "ecr_repository_names" {
  type    = list(string)
  default = ["inspect-lens-be", "inspect-image-analyzer"]
}

variable "github_deploy_environments" {
  type    = list(string)
  default = ["staging", "production"]
}

variable "github_build_allowed_refs" {
  description = "Refs that may assume the build role. inspect-lens-be cd.yml builds on tag pushes v*.*.* and workflow_dispatch; dispatch from other branches is denied."
  type        = list(string)
  default     = ["refs/heads/main", "refs/tags/v*"]
}

variable "tags" {
  type    = map(string)
  default = {}
}
