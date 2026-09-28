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

variable "instance_type" {
  type    = string
  default = "t3.small"
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

variable "alb_security_group_id" {
  type    = string
  default = ""
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

variable "tags" {
  type    = map(string)
  default = {}
}

variable "existing_ami_id" {
  description = "AMI ID of the existing EC2 instance being adopted."
  type        = string
}

variable "existing_instance_profile_name" {
  description = "Existing EC2 IAM instance profile."
  type        = string
}

variable "existing_security_group_ids" {
  description = "Existing security groups attached to the EC2 instance."
  type        = list(string)
}

variable "existing_instance_name" {
  description = "Existing EC2 Name tag."
  type        = string
}