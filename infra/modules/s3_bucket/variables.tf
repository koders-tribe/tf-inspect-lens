variable "bucket_name" {
  description = "Name of the S3 bucket. If the bucket already exists, import it before the first apply."
  type        = string
}

variable "tags" {
  description = "Common tags applied to AWS resources."
  type        = map(string)
  default     = {}
}

variable "cors_allowed_origins" {
  description = "Browser origins allowed to PUT/GET via presigned URLs. Empty list skips the CORS resource."
  type        = list(string)
  default     = []
}

variable "force_destroy" {
  description = "Let destroy delete the bucket with all objects and versions in it. Practice accounts only."
  type        = bool
  default     = false
}

variable "abort_incomplete_multipart_days" {
  description = "Abort incomplete multipart uploads after this many days."
  type        = number
  default     = 7
}
