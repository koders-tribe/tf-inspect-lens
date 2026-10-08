variable "account_id" {
  description = "AWS account ID this state bucket belongs to. The provider refuses any other account."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "account_id must be a 12-digit AWS account ID."
  }
}

variable "aws_region" {
  description = "Region for the state bucket. Use the same region as the stack it serves."
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile. Leave null and use AWS_PROFILE or exported credentials."
  type        = string
  default     = null
}

variable "project_name" {
  description = "Prefix for the bucket name."
  type        = string
  default     = "inspect-lens"
}

variable "state_bucket_name" {
  description = "Override the bucket name. Null means <project_name>-terraform-state-<account_id>-<aws_region>."
  type        = string
  default     = null
}

variable "noncurrent_version_retention_days" {
  description = "Days to keep old state versions before expiring them."
  type        = number
  default     = 90
}
