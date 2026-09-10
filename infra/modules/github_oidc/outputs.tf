output "oidc_provider_arn" {
  value = local.oidc_provider_arn
}

output "build_role_arn" {
  description = "Set as GitHub Actions variable AWS_ROLE_ARN (ECR push)."
  value       = aws_iam_role.build.arn
}

output "deploy_role_arn" {
  description = "Set as GitHub Environment variable AWS_DEPLOY_ROLE_ARN (SSM deploy)."
  value       = aws_iam_role.deploy.arn
}
