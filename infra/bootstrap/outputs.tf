output "state_bucket_name" {
  description = "Put this in infra/environments/dev/config/backend-<name>.hcl as bucket."
  value       = aws_s3_bucket.state.id
}

output "state_bucket_region" {
  value = aws_s3_bucket.state.region
}

output "backend_config" {
  description = "Contents for infra/environments/dev/config/backend-<name>.hcl."
  value       = <<-EOT
    bucket       = "${aws_s3_bucket.state.id}"
    key          = "dev/terraform.tfstate"
    region       = "${var.aws_region}"
    encrypt      = true
    use_lockfile = true
  EOT
}
