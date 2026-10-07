variable "name_prefix" {
  description = "Prefix for RDS identifiers, e.g. inspect-lens-dev."
  type        = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "engine_version" {
  description = "PostgreSQL major version. RDS picks its current default minor in the region; auto_minor_version_upgrade moves it forward without a plan diff."
  type        = string
  default     = "16"
}

variable "secret_recovery_window_days" {
  description = "Recovery window for the DATABASE_URL secret. 0 deletes immediately (practice accounts)."
  type        = number
  default     = 30
}

variable "instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "db_name" {
  type    = string
  default = "inspect_lens"
}

variable "username" {
  type    = string
  default = "inspect_lens"
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "backup_retention_period" {
  type    = number
  default = 7
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
