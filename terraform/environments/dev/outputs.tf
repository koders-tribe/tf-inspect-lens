###############################################################################
# Bucket Name
###############################################################################

output "bucket_name" {

  description = "Managed S3 bucket name."

  value = module.s3_bucket.bucket_id

}

###############################################################################
# Bucket ARN
###############################################################################

output "bucket_arn" {

  description = "Managed S3 bucket ARN."

  value = module.s3_bucket.bucket_arn

}

###############################################################################
# Bucket Region
###############################################################################

output "bucket_region" {

  description = "Managed S3 bucket region."

  value = module.s3_bucket.bucket_region

}

####################################################
# IAM User
####################################################

output "iam_user_name" {

  value = module.iam.iam_user_name

}

####################################################
# IAM Group
####################################################

output "iam_group_name" {

  value = module.iam.iam_group_name

}

####################################################
# IAM Group ARN
####################################################

output "iam_group_arn" {

  value = module.iam.iam_group_arn

}