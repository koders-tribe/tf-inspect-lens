output "bucket_name" {
  description = "Set S3_BUCKET in app.env"
  value       = module.s3_bucket.bucket_id
}

output "bucket_arn" {
  value = module.s3_bucket.bucket_arn
}

output "bucket_region" {
  description = "Set S3_REGION in app.env"
  value       = module.s3_bucket.bucket_region
}

output "iam_user_name" {
  description = "Create an access key for this user in the IAM console. Set AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY in app.env. Never commit keys. Null when create_app_iam_user is false."
  value       = module.iam.iam_user_name
}

output "iam_group_name" {
  description = "Null when create_app_iam_user is false."
  value       = module.iam.iam_group_name
}

output "app_policy_arn" {
  value = module.iam.app_policy_arn
}

output "ses_email_identity" {
  value = module.ses.email_identities
}

output "ses_email_identity_arns" {
  value = module.ses.email_identity_arns
}

output "ses_domain_identity" {
  value = module.ses.domain_identity
}

output "ses_dkim_tokens" {
  description = "Publish these as CNAMEs if Route53 is not wired."
  value       = module.ses.dkim_tokens
}

output "ecr_repository_names" {
  description = "GitHub variables ECR_REPOSITORY and ECR_ANALYZER_REPOSITORY (names, not URIs)."
  value       = try(module.ecr[0].repository_names, [])
}

output "ecr_repository_urls" {
  value = try(module.ecr[0].repository_urls, {})
}

output "github_build_role_arn" {
  description = "GitHub Actions variable AWS_ROLE_ARN"
  value       = try(module.github_oidc[0].build_role_arn, null)
}

output "github_deploy_role_arn" {
  description = "GitHub Environment variable AWS_DEPLOY_ROLE_ARN"
  value       = try(module.github_oidc[0].deploy_role_arn, null)
}

output "rds_endpoint" {
  value     = try(module.rds[0].endpoint, null)
  sensitive = false
}

output "database_url_secret_name" {
  description = "Copy this secret into app.env DATABASE_URL on the EC2 host. Do not put it in GitHub Actions."
  value       = try(module.rds[0].database_url_secret_name, null)
}

output "app_secret_name" {
  value = try(module.secrets[0].app_secret_name, null)
}

output "analyzer_secret_name" {
  value = try(module.secrets[0].analyzer_secret_name, null)
}

output "ec2_instance_id" {
  description = "GitHub Environment variable EC2_INSTANCE_IDS"
  value       = try(module.compute[0].instance_id, null)
}

output "ec2_deploy_path" {
  description = "GitHub Environment variable EC2_DEPLOY_PATH"
  value       = var.enable_compute ? var.ec2_deploy_path : null
}

output "app_healthcheck_url" {
  description = "GitHub Environment variable APP_HEALTHCHECK_URL"
  value       = try(module.compute[0].healthcheck_url, null)
}

output "ses_sender" {
  description = "EMAIL_SENDER in app.env."
  value       = local.ses_sender
}

output "ec2_public_ip" {
  value = try(module.compute[0].instance_public_ip, null)
}

output "api_url" {
  description = "APP_PUBLIC_URL: ALB URL, or http://<ip>:<port> with enable_public_http."
  value       = try(module.compute[0].api_url, null)
}

output "app_env" {
  description = "Non-secret app.env values. DATABASE_URL is read from the named secret on the host; secret values are never output."
  value = {
    S3_BUCKET                = module.s3_bucket.bucket_id
    S3_REGION                = var.aws_region
    SES_REGION               = var.aws_region
    EMAIL_SENDER             = local.ses_sender
    DATABASE_URL_SECRET_NAME = try(module.rds[0].database_url_secret_name, null)
    APP_SECRET_NAME          = try(module.secrets[0].app_secret_name, null)
    APP_PUBLIC_URL           = try(module.compute[0].api_url, null)
    EC2_INSTANCE_ID          = try(module.compute[0].instance_id, null)
    ECR_REPOSITORY_URLS      = try(module.ecr[0].repository_urls, {})
  }
}

output "github_actions_handoff" {
  description = "Values to paste into inspect-lens-be GitHub settings after apply."
  value = {
    AWS_REGION              = var.aws_region
    ECR_REPOSITORY          = try(var.ecr_repository_names[0], null)
    ECR_ANALYZER_REPOSITORY = try(var.ecr_repository_names[1], null)
    AWS_ROLE_ARN            = try(module.github_oidc[0].build_role_arn, null)
    AWS_DEPLOY_ROLE_ARN     = try(module.github_oidc[0].deploy_role_arn, null)
    EC2_INSTANCE_IDS        = try(module.compute[0].instance_id, null)
    EC2_DEPLOY_PATH         = var.enable_compute ? var.ec2_deploy_path : null
    EC2_TARGET_TAG_KEY      = "Name"
    EC2_TARGET_TAG_VALUE    = var.enable_compute ? "inspect-lens-${var.environment}-app" : null
    APP_HEALTHCHECK_URL     = try(module.compute[0].healthcheck_url, null)
  }
}
