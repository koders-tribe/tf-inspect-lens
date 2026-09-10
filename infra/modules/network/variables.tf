variable "name_prefix" {
  description = "Prefix for VPC and related resource names, e.g. inspect-lens-dev."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  default     = "10.20.0.0/16"
}

variable "az_count" {
  description = "Number of availability zones (2 recommended)."
  type        = number
  default     = 2
}

variable "enable_nat_gateway" {
  description = "Create a single NAT gateway so private subnets can reach the internet (RDS patches, yum). Skip if EC2 stays in a public subnet."
  type        = bool
  default     = false
}

variable "enable_vpc_endpoints" {
  description = "Interface/gateway endpoints for SSM, ECR, S3, Secrets Manager, and logs. Use when instances are private and NAT is off."
  type        = bool
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
