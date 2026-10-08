output "iam_user_name" {
  description = "IAM user name, or null when create_user is false."
  value       = try(aws_iam_user.this[0].name, null)
}

output "iam_user_arn" {
  description = "IAM user ARN, or null when create_user is false."
  value       = try(aws_iam_user.this[0].arn, null)
}

output "iam_group_name" {
  description = "IAM group name, or null when create_user is false."
  value       = try(aws_iam_group.this[0].name, null)
}

output "iam_group_arn" {
  description = "IAM group ARN, or null when create_user is false."
  value       = try(aws_iam_group.this[0].arn, null)
}

output "app_policy_arn" {
  description = "Least-privilege app policy ARN, if created."
  value       = try(aws_iam_policy.app[0].arn, null)
}
