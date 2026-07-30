###############################################################################
# Existing S3 Bucket Name
###############################################################################

variable "bucket_name" {

  description = "Name of the existing S3 bucket to be managed by Terraform."

  type = string

}

###############################################################################
# Common Resource Tags
###############################################################################

variable "tags" {

  description = "Common tags applied to AWS resources."

  type = map(string)

  default = {}

}