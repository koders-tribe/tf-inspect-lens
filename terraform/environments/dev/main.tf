###############################################################################
# S3 Bucket Module
###############################################################################

module "s3_bucket" {

  source = "../../modules/s3_bucket"

  bucket_name = var.bucket_name

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }

}

##################################################
# IAM Module
##################################################

module "iam" {

  source = "../../modules/iam"

  iam_user_name  = var.iam_user_name
  iam_group_name = var.iam_group_name

  policy_arns = var.policy_arns

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }

}

##################################################
# SES Modules
##################################################

module "ses" {
  source = "../../modules/ses"

  emails = var.ses_emails
}