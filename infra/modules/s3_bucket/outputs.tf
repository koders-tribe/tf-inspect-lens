output "bucket_id" {
  description = "The name (ID) of the S3 bucket."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket."
  value       = aws_s3_bucket.this.arn
}

output "bucket_region" {
  description = "AWS region where the bucket exists."
  value       = aws_s3_bucket.this.region
}

output "bucket_domain_name" {
  description = "Bucket regional domain name (for CORS / presigned virtual-hosted URLs)."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}
