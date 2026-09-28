data "aws_vpc" "existing" {
  id = var.existing_vpc_id
}

data "aws_subnet" "public" {
  for_each = toset(var.public_subnet_ids)

  id = each.value
}

data "aws_subnet" "private" {
  for_each = toset(var.private_subnet_ids)

  id = each.value
}

data "aws_security_group" "app" {
  id = var.existing_app_security_group_id
}

data "aws_security_group" "rds" {
  id = var.existing_rds_security_group_id
}