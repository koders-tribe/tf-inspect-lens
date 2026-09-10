output "app_secret_arn" {
  value = aws_secretsmanager_secret.app.arn
}

output "app_secret_name" {
  value = aws_secretsmanager_secret.app.name
}

output "analyzer_secret_arn" {
  value = aws_secretsmanager_secret.analyzer.arn
}

output "analyzer_secret_name" {
  value = aws_secretsmanager_secret.analyzer.name
}
