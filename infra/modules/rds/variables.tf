variable "name_prefix" {
  description = "Prefix used for supporting resources."
  type        = string
}

variable "private_subnet_ids" {
  description = "Existing private subnet IDs used by the RDS subnet group."
  type        = list(string)
}

variable "security_group_id" {
  description = "Existing RDS security group ID."
  type        = string
}

variable "existing_db_identifier" {
  description = "Existing RDS instance identifier to adopt."
  type        = string
}

variable "existing_db_subnet_group_name" {
  description = "Existing RDS DB subnet group name to adopt."
  type        = string
}

variable "engine_version" {
  description = "PostgreSQL engine version."
  type        = string
  default     = "18.3"
}

variable "instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "max_allocated_storage" {
  type    = number
  default = 1000
}

variable "db_name" {
  type    = string
  default = null
}

variable "username" {
  type    = string
  default = "postgres"
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "backup_retention_period" {
  type    = number
  default = 1
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}