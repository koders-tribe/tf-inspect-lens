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

variable "ec2_instance_arns" {
  description = "Optional EC2 instance ARNs to scope ssm:SendCommand. Empty allows tagged instances via a wildcard (tighten later)."
  type        = list(string)
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
