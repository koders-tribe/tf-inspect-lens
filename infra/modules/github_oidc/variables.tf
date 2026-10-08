variable "name_prefix" {
  description = "Prefix for IAM role names, e.g. inspect-lens-dev."
  type        = string
}

variable "github_org" {
  type    = string
  default = "koders-tribe"
}

variable "github_repo" {
  description = "Application repository that assumes these roles (inspect-lens-be)."
  type        = string
  default     = "inspect-lens-be"
}

variable "create_oidc_provider" {
  description = "Create the GitHub OIDC provider. Set false if the account already has token.actions.githubusercontent.com."
  type        = bool
  default     = true
}

variable "ecr_repository_arns" {
  description = "ECR repository ARNs the build role may push to."
  type        = list(string)
}

variable "deploy_environments" {
  description = "GitHub Environment names allowed to assume the deploy role."
  type        = list(string)
  default     = ["staging", "production"]
}

variable "build_allowed_refs" {
  description = "Git refs allowed to assume the build (ECR push) role. Default matches inspect-lens-be cd.yml: tag pushes v*.*.* and workflow_dispatch from main."
  type        = list(string)
  default     = ["refs/heads/main", "refs/tags/v*"]
}

variable "ec2_instance_arns" {
  description = "Optional EC2 instance ARNs to scope ssm:SendCommand. Empty means any instance in the account that carries the deploy target tag."
  type        = list(string)
  default     = []
}

variable "deploy_target_tag_key" {
  description = "Tag key an instance must carry for the deploy role to run SendCommand on it."
  type        = string
  default     = "Name"
}

variable "deploy_target_tag_value" {
  description = "Tag value for deploy_target_tag_key. Null means <name_prefix>-app, the Name the compute module sets."
  type        = string
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
