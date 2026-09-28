output "instance_id" {
  description = "Set as GitHub Environment variable EC2_INSTANCE_IDS, or target by tag Name."
  value       = aws_instance.this.id
}

output "instance_private_ip" {
  value = aws_instance.this.private_ip
}

output "instance_public_ip" {
  value = aws_instance.this.public_ip
}

output "instance_profile_name" {
  value = data.aws_iam_instance_profile.existing.name
}

output "deploy_path" {
  value = var.deploy_path
}

output "alb_dns_name" {
  description = "Public ALB DNS for APP_HEALTHCHECK_URL / APP_PUBLIC_URL."
  value       = try(aws_lb.this[0].dns_name, null)
}

output "healthcheck_url" {
  value = var.enable_alb ? (
    var.acm_certificate_arn != "" ?
    "https://${aws_lb.this[0].dns_name}/health" :
    "http://${aws_lb.this[0].dns_name}/health"
  ) : null
}
