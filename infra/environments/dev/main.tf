locals {
  name_prefix = "inspect-lens-${var.environment}"
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
  })
}

###############################################################################
# S3 — photos, quotation PDFs, inspection-report PDFs
###############################################################################

module "s3_bucket" {
  source = "../../modules/s3_bucket"

  bucket_name          = var.bucket_name
  cors_allowed_origins = var.cors_allowed_origins
  tags                 = local.common_tags
}

###############################################################################
# SES — password reset, email verification, agreement PDF attachments
###############################################################################

module "ses" {
  source = "../../modules/ses"

  emails          = var.ses_emails
  domain          = var.ses_domain
  route53_zone_id = var.ses_route53_zone_id
  tags            = local.common_tags
}

###############################################################################
# IAM user for the running API (static keys). Do not generate keys in Terraform.
###############################################################################

module "iam" {
  source = "../../modules/iam"

  iam_user_name     = var.iam_user_name
  iam_group_name    = var.iam_group_name
  policy_arns       = var.policy_arns
  s3_bucket_arn     = module.s3_bucket.bucket_arn
  ses_identity_arns = module.ses.all_identity_arns
  attach_app_policy = true
  tags              = local.common_tags
}

###############################################################################
# Optional platform (Inspect Lens CD: ECR → EC2 via SSM, RDS)
###############################################################################

module "network" {
  count  = var.enable_network ? 1 : 0
  source = "../../modules/network"

  name_prefix          = local.name_prefix
  vpc_cidr             = var.vpc_cidr
  enable_nat_gateway   = var.enable_nat_gateway
  enable_vpc_endpoints = var.enable_vpc_endpoints
  tags                 = local.common_tags
}

module "rds" {
  count  = var.enable_network && var.enable_rds ? 1 : 0
  source = "../../modules/rds"

  name_prefix        = local.name_prefix
  private_subnet_ids = module.network[0].private_subnet_ids
  security_group_id  = module.network[0].rds_security_group_id
  instance_class     = var.db_instance_class
  db_name            = var.db_name
  username           = var.db_username
  tags               = local.common_tags
}

module "ecr" {
  count  = var.enable_ecr ? 1 : 0
  source = "../../modules/ecr"

  repository_names = var.ecr_repository_names
  tags             = local.common_tags
}

module "github_oidc" {
  count  = var.enable_github_oidc && var.enable_ecr ? 1 : 0
  source = "../../modules/github_oidc"

  name_prefix          = local.name_prefix
  github_org           = var.github_org
  github_repo          = var.github_repo
  create_oidc_provider = var.create_github_oidc_provider
  ecr_repository_arns  = values(module.ecr[0].repository_arns)
  deploy_environments  = var.github_deploy_environments
  tags                 = local.common_tags
}

module "secrets" {
  count  = var.enable_secrets ? 1 : 0
  source = "../../modules/secrets"

  name_prefix = local.name_prefix
  tags        = local.common_tags
}

module "compute" {
  count  = var.enable_network && var.enable_compute ? 1 : 0
  source = "../../modules/compute"

  name_prefix           = local.name_prefix
  vpc_id                = module.network[0].vpc_id
  subnet_id             = module.network[0].public_subnet_ids[0]
  app_security_group_id = module.network[0].app_security_group_id
  alb_security_group_id = module.network[0].alb_security_group_id
  ecr_repository_arns   = var.enable_ecr ? values(module.ecr[0].repository_arns) : []
  instance_type         = var.ec2_instance_type
  deploy_path           = var.ec2_deploy_path
  enable_alb            = var.enable_alb
  acm_certificate_arn   = var.acm_certificate_arn
  public_subnet_ids     = module.network[0].public_subnet_ids
  tags                  = local.common_tags
}
