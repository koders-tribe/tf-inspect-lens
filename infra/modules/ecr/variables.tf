variable "repository_names" {
  description = "ECR repository names (not URIs). Inspect Lens CD needs inspect-lens-be and inspect-image-analyzer."
  type        = list(string)
}

variable "keep_image_count" {
  description = "Lifecycle: keep this many tagged images per repository."
  type        = number
  default     = 20
}

variable "tags" {
  type    = map(string)
  default = {}
}
