# Placeholder secrets for values that must never live in GitHub Actions.
# Fill versions in the console or CLI after apply. RDS DATABASE_URL is created in the rds module.

resource "aws_secretsmanager_secret" "app" {
  name        = "${var.name_prefix}/app-env"
  description = "Non-database inspect-lens-be runtime secrets for app.env (JWT, AWS keys, Google, analyzer token, email)."
  tags        = var.tags

  recovery_window_in_days = var.recovery_window_in_days
}

resource "aws_secretsmanager_secret" "analyzer" {
  name        = "${var.name_prefix}/analyzer-env"
  description = "inspect-image-analyzer runtime secrets for analyzer.env (LLM keys, token API key)."
  tags        = var.tags

  recovery_window_in_days = var.recovery_window_in_days
}
