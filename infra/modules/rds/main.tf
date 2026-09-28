data "aws_db_subnet_group" "existing" {
  name = var.existing_db_subnet_group_name
}
resource "aws_db_instance" "this" {
  identifier = var.existing_db_identifier

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp2"

  storage_encrypted = true

  db_name  = var.db_name
  username = var.username

  db_subnet_group_name   = data.aws_db_subnet_group.existing.name
  vpc_security_group_ids = [var.security_group_id]

  publicly_accessible = false
  multi_az            = var.multi_az

  backup_retention_period    = var.backup_retention_period
  deletion_protection        = var.deletion_protection
  skip_final_snapshot        = true
  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true

  monitoring_interval          = 60
  performance_insights_enabled = true

  apply_immediately = false

  tags = merge(var.tags, {
    Name = var.existing_db_identifier
  })
}