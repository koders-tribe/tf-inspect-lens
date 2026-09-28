output "oidc_provider_arn" {
  value = local.oidc_provider_arn
}

output "github_actions_role_arn" {
  description = "GitHub Actions IAM role ARN."
  value       = aws_iam_role.github_actions.arn
}
