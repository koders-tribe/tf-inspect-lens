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

variable "tags" {
  type    = map(string)
  default = {}
}
