output "iam_user_name" {
  description = "IAM user name."
  value       = aws_iam_user.this.name
}

output "iam_user_arn" {
  description = "IAM user ARN."
  value       = aws_iam_user.this.arn
}

output "iam_group_name" {
  description = "IAM group name."
  value       = aws_iam_group.this.name
}

output "iam_group_arn" {
  description = "IAM group ARN."
  value       = aws_iam_group.this.arn
}

output "app_policy_arn" {
  description = "Least-privilege app policy ARN, if created."
  value       = try(aws_iam_policy.app[0].arn, null)
}
