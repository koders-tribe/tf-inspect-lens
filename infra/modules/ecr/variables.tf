variable "repositories" {
  description = "ECR repository configuration for Inspect Lens."
  type = map(object({
    image_tag_mutability = string
    scan_on_push         = bool
  }))
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
