output "instance_id" {
  description = "Set as GitHub Environment variable EC2_INSTANCE_IDS, or target by tag Name."
  value       = aws_instance.this.id
}

output "instance_private_ip" {
  value = aws_instance.this.private_ip
}

output "instance_public_ip" {
  description = "Elastic IP when enable_eip, otherwise the auto-assigned IP (changes on stop/start)."
  value       = local.public_ip
}

output "instance_role_name" {
  value = aws_iam_role.instance.name
}

output "api_url" {
  description = "Base URL of the API: the ALB when enabled, else http://<public ip>:<port> when public_http, else null."
  value       = local.api_url
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.this.name
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
