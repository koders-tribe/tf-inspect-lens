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
