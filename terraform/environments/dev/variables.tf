###############################################################################
# AWS Region
###############################################################################

variable "aws_region" {

  description = "AWS Region where infrastructure exists."

  type = string

  default = "ap-south-1"

}

###############################################################################
# AWS CLI Profile
###############################################################################

variable "aws_profile" {

  description = "AWS CLI profile name."

  type = string

  default = "default"

}

###############################################################################
# Project Name
###############################################################################

variable "project_name" {

  description = "Project name used for resource tagging."

  type = string

  default = "InspectLens"

}

###############################################################################
# Environment Name
###############################################################################

variable "environment" {

  description = "Deployment environment."

  type = string

  default = "dev"

}

###############################################################################
# Existing Bucket Name
###############################################################################

variable "bucket_name" {

  description = "Existing S3 bucket name."

  type = string

}

###############################################################################
# Common Resource Tags
###############################################################################

variable "tags" {

  description = "Common tags applied to all AWS resources."

  type = map(string)

  default = {}

}

####################################################
# IAM User
####################################################

variable "iam_user_name" {

  description = "IAM User Name"

  type = string

}

####################################################
# IAM Group
####################################################

variable "iam_group_name" {

  description = "IAM Group Name"

  type = string

}

####################################################
# policy_arns
####################################################

variable "policy_arns" {

  description = "IAM policies."

  type = list(string)

}