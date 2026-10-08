output "endpoint" {
  description = "RDS hostname (no port)."
  value       = aws_db_instance.this.address
}

output "port" {
  value = aws_db_instance.this.port
}

output "db_name" {
  value = aws_db_instance.this.db_name
}

output "backup_retention_period" {
  description = "Automated backup retention in days."
  value       = aws_db_instance.this.backup_retention_period
}

output "username" {
  value = aws_db_instance.this.username
}

output "database_url_secret_arn" {
  description = "Secrets Manager ARN containing DATABASE_URL. Do not put this in GitHub Actions."
  value       = aws_secretsmanager_secret.database_url.arn
}

output "database_url_secret_name" {
  value = aws_secretsmanager_secret.database_url.name
}
