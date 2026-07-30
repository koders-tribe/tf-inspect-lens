# Dev Environment: S3 Bucket Configuration

**Environment**: Development  
**Region**: ap-south-1 (Mumbai)  
**Status**: ✅ Active  

---

## Quick Start

```bash
# 1. Setup
cd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars  # Update bucket_name

# 2. Validate
terraform init
terraform validate

# 3. Import existing bucket
terraform import module.s3_bucket.aws_s3_bucket.this <BUCKET-NAME>

# 4. Review and apply
terraform plan
terraform apply

# 5. Verify
terraform output
```

---

## Configuration Files

### `provider.tf`
- AWS region: ap-south-1
- AWS provider: ~> 5.0
- Terraform version: >= 1.5
- Default tags: Project=inspect-lens, ManagedBy=terraform

### `variables.tf`
- `aws_region`: ap-south-1 (required)
- `aws_profile`: inspect-lens-dev (optional, has default)
- `bucket_name`: Required, must match existing bucket
- `tags`: Optional, {Environment: dev, Owner: DevOps}

### `terraform.tfvars`
**IMPORTANT**: Create from .example, DO NOT commit actual .tfvars

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit and update values
```

---

## AWS Credentials Setup

```bash
# Configure AWS CLI profile
aws configure --profile inspect-lens-dev

# Verify it works
aws sts get-caller-identity --profile inspect-lens-dev

# Should output:
# {
#   "UserId": "...",
#   "Account": "055255093542",
#   "Arn": "arn:aws:iam::055255093542:user/..."
# }
```

---

## Verification Commands

```bash
# 1. Check Terraform state
terraform state list
terraform state show module.s3_bucket.aws_s3_bucket.this

# 2. View outputs
terraform output

# 3. Verify AWS configuration
aws s3api get-bucket-versioning --bucket <BUCKET-NAME> --profile inspect-lens-dev
aws s3api get-bucket-encryption --bucket <BUCKET-NAME> --profile inspect-lens-dev
aws s3api get-public-access-block --bucket <BUCKET-NAME> --profile inspect-lens-dev
aws s3api get-bucket-tagging --bucket <BUCKET-NAME> --profile inspect-lens-dev
```

---

## Common Operations

### Update Tags
```bash
# Edit terraform.tfvars
nano terraform.tfvars

# Update tags variable
tags = {
  Environment = "dev"
  Owner       = "DevOps"
  CostCenter  = "12345"
}

# Apply
terraform plan
terraform apply
```

### Check for Drift
```bash
# Compare desired vs actual state
terraform plan
# If "Plan: 0 to add, 0 to change, 0 to destroy" - NO DRIFT
# Otherwise - configuration drift detected
```

### View All Outputs
```bash
terraform output
# or
terraform output -json
```

---

## Troubleshooting

**Error: "NoSuchBucket"**
- Check bucket name in terraform.tfvars
- Verify bucket exists in AWS: `aws s3 ls --profile inspect-lens-dev`

**Error: "AccessDenied"**
- AWS credentials don't have S3 permissions
- Verify profile works: `aws sts get-caller-identity --profile inspect-lens-dev`

**Error: "No value for required variable"**
- Run: `cp terraform.tfvars.example terraform.tfvars`
- Edit terraform.tfvars with actual values

**State out of sync**
```bash
# Refresh state from AWS
terraform refresh

# If issue persists, re-import
terraform import module.s3_bucket.aws_s3_bucket.this <BUCKET-NAME>
```

---

## Resource Details

### S3 Bucket Configuration

**Versioning**: ✅ Enabled
- Protects against accidental deletion
- Previous versions recoverable
- Cost: storage used by all versions

**Encryption**: ✅ AES256 (S3-managed)
- Free encryption
- Automatic and transparent
- Protects data at rest

**Public Access**: ✅ Fully Blocked (4-layer)
- No public ACLs
- No public policies
- Maximum security posture

**Tags**: ✅ Applied
- Project: inspect-lens
- ManagedBy: terraform
- Environment: dev
- Owner: DevOps

---

## File Locations

```
environments/dev/
├── provider.tf                  (AWS config)
├── main.tf                      (Module instantiation)
├── variables.tf                 (Input variables)
├── outputs.tf                   (Export values)
├── terraform.tfvars.example     (Safe template)
├── README.md                    (This file)
│
├── (NOT COMMITTED)
│   ├── terraform.tfvars         (Actual values, .gitignored)
│   ├── .terraform/              (Provider cache, .gitignored)
│   └── terraform.tfstate*       (State files, .gitignored)
```

---

## Links

- [Main README](../../README.md) - Complete project documentation
- [Module Documentation](../../modules/s3_bucket/README.md) - S3 module details
- [AWS S3 Docs](https://docs.aws.amazon.com/s3/) - Official AWS S3 documentation
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest) - AWS provider docs
