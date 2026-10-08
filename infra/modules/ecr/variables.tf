variable "repository_names" {
  description = "ECR repository names (not URIs). Inspect Lens CD needs inspect-lens-be and inspect-image-analyzer."
  type        = list(string)
}

variable "keep_image_count" {
  description = "Lifecycle: keep this many tagged images per repository."
  type        = number
  default     = 20
}

variable "force_delete" {
  description = "Let destroy delete repositories that still contain images. Practice accounts only."
  type        = bool
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
