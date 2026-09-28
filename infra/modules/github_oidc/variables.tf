variable "name_prefix" {
  description = "Prefix for IAM role names, e.g. inspect-lens-dev."
  type        = string
}

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

variable "create_oidc_provider" {
  description = "Create the GitHub OIDC provider. Set false if the account already has token.actions.githubusercontent.com."
  type        = bool
  default     = true
}

variable "ecr_repository_arns" {
  description = "ECR repository ARNs the GitHub Actions role may push to."
  type        = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "role_name" {
  description = "Existing GitHub Actions IAM role name."
  type        = string
  default     = "GitHubActionsInspectLensCDRole"
}