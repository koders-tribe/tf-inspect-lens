variable "iam_user_name" {
  description = "IAM user the Inspect Lens API uses for S3 and SES (static keys until the app supports instance roles)."
  type        = string
}

variable "iam_group_name" {
  description = "IAM group the app user belongs to."
  type        = string
}

variable "policy_arns" {
  description = "Optional extra managed/custom policy ARNs attached to the group. Prefer the module app policy over AmazonS3FullAccess / AmazonSESFullAccess."
  type        = list(string)
  default     = []
}

variable "s3_bucket_arn" {
  description = "ARN of the app S3 bucket. Used to scope object access to findings/*, inspection-reports/*, and quotation-agreements/*."
  type        = string
  default     = ""
}

variable "ses_identity_arns" {
  description = "SES identity ARNs the app may send from (email and/or domain)."
  type        = list(string)
  default     = []
}

variable "attach_app_policy" {
  description = "Create and attach a least-privilege S3 + SES policy for the app user."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
  default     = {}
}
