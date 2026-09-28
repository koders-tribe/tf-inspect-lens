variable "existing_vpc_id" {
  description = "Existing VPC ID to reuse."
  type        = string
}

variable "public_subnet_ids" {
  description = "Existing public subnet IDs to reuse."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Existing private subnet IDs to reuse."
  type        = list(string)
}

variable "existing_app_security_group_id" {
  description = "Existing EC2/app security group ID to reuse."
  type        = string
}

variable "existing_rds_security_group_id" {
  description = "Existing RDS security group ID to reuse."
  type        = string
}