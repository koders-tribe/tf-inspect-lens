output "vpc_id" {
  value = data.aws_vpc.existing.id
}

output "public_subnet_ids" {
  value = var.public_subnet_ids
}

output "private_subnet_ids" {
  value = var.private_subnet_ids
}

output "alb_security_group_id" {
  value = data.aws_security_group.app.id
}

output "app_security_group_id" {
  value = data.aws_security_group.app.id
}

output "rds_security_group_id" {
  value = data.aws_security_group.rds.id
}