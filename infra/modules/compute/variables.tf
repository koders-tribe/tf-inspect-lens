variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  description = "Subnet for the EC2 instance. Use a public subnet when NAT is disabled."
  type        = string
}

variable "app_security_group_id" {
  type = string
}

variable "alb_security_group_id" {
  type = string
}

variable "ecr_repository_arns" {
  description = "ECR repos the instance may pull."
  type        = list(string)
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "root_volume_gb" {
  type    = number
  default = 40
}

variable "swap_gb" {
  description = "Swap file size created on first boot. 0 = no swap."
  type        = number
  default     = 0
}

variable "enable_eip" {
  description = "Attach an Elastic IP so the public address survives stop/start."
  type        = bool
  default     = false
}

variable "public_http" {
  description = "Whether the app port is reachable directly (network public_app_ingress_cidrs). Only used to build api_url."
  type        = bool
  default     = false
}

variable "extra_policy_arns" {
  description = "Extra managed policies for the instance role (e.g. the app's scoped S3 + SES policy)."
  type        = list(string)
  default     = []
}

variable "uploads_volume_gb" {
  description = "EBS volume mounted for local profile/signature uploads (FileUploadService). 0 skips the volume."
  type        = number
  default     = 20
}

variable "uploads_mount_path" {
  description = "Where user_data mounts the uploads volume."
  type        = string
  default     = "/opt/inspect-lens-uploads"
}

variable "deploy_path" {
  description = "Directory on the host for deploy/ec2 (EC2_DEPLOY_PATH)."
  type        = string
  default     = "/opt/inspect-lens-be"
}

variable "app_host_port" {
  description = "Host port mapped to the API container (compose APP_HOST_PORT)."
  type        = number
  default     = 8001
}

variable "enable_alb" {
  type    = bool
  default = false
}

variable "acm_certificate_arn" {
  description = "If set with enable_alb, ALB listens on 443. Otherwise HTTP 80."
  type        = string
  default     = ""
}

variable "public_subnet_ids" {
  description = "Public subnets for the ALB (required when enable_alb is true)."
  type        = list(string)
  default     = []
}

variable "allowed_ssh_cidrs" {
  description = "Leave empty (recommended). CD uses SSM, not SSH."
  type        = list(string)
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
