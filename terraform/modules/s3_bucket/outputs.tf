###############################################################################
# Bucket ID
###############################################################################

output "bucket_id" {

  description = "The name (ID) of the S3 bucket."

  value = aws_s3_bucket.this.id

}

###############################################################################
# Bucket ARN
###############################################################################

output "bucket_arn" {

  description = "The ARN of the S3 bucket."

  value = aws_s3_bucket.this.arn

}

###############################################################################
# Bucket Region
###############################################################################

output "bucket_region" {

  description = "AWS Region where the bucket exists."

  value = aws_s3_bucket.this.region

}