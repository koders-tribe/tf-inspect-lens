# Module: s3_bucket

A reusable Terraform module for managing AWS S3 buckets with security best practices.

**Version**: 1.0.0  
**Status**: Production Ready  

---

## Module Purpose

Manages an existing AWS S3 bucket with the following features:
- **Bucket Management**: Import existing buckets
- **Versioning**: Enable version history for data protection
- **Encryption**: AES256 server-side encryption
- **Security**: Block all public access (4-layer protection)
- **Tags**: Resource metadata and organization

---

## Usage

### Basic Example

```hcl
module "s3_bucket" {
  source = "../../modules/s3_bucket"
  
  bucket_name = "my-bucket-name"
  tags = {
    Environment = "dev"
    Owner       = "platform-team"
  }
}
```

### Access Module Outputs

```hcl
# Get bucket name
bucket_id = module.s3_bucket.bucket_id
# Output: "my-bucket-name"

# Get bucket ARN (for IAM policies)
bucket_arn = module.s3_bucket.bucket_arn
# Output: "arn:aws:s3:::my-bucket-name"

# Check if versioning is enabled
versioning_enabled = module.s3_bucket.versioning_enabled
# Output: true
```

---

## Required Inputs

### `bucket_name`
- **Type**: string
- **Description**: Name of the existing S3 bucket to manage
- **Validation**: 3-63 characters, lowercase, alphanumeric with hyphens/dots
- **Example**: `inspect-lens-demo-dev-055255093542-ap-south-1-an`

---

## Optional Inputs

### `tags`
- **Type**: map(string)
- **Default**: {}
- **Description**: Tags to apply to the bucket
- **Example**:
  ```hcl
  tags = {
    Environment = "dev"
    CostCenter  = "engineering"
    Team        = "platform"
  }
  ```

---

## Outputs

### `bucket_id`
- **Type**: string
- **Description**: Name of the S3 bucket
- **Use Case**: Application configuration, scripts, documentation

### `bucket_arn`
- **Type**: string
- **Description**: Amazon Resource Name of the bucket
- **Use Case**: IAM policies, bucket policies, integrations

### `versioning_enabled`
- **Type**: bool
- **Description**: Whether versioning is enabled
- **Use Case**: Compliance checks, automation logic

---

## Resources Created

| Resource | Name | Purpose |
|----------|------|---------|
| `aws_s3_bucket` | `this` | S3 bucket (imported, not created) |
| `aws_s3_bucket_versioning` | `this` | Enable version tracking |
| `aws_s3_bucket_server_side_encryption_configuration` | `this` | AES256 encryption |
| `aws_s3_bucket_public_access_block` | `this` | Block public access |

---

## Features

### 1. Bucket Import
- **What**: Adopts existing AWS S3 bucket
- **Why**: Bucket already exists; import prevents data loss
- **How**: `terraform import module.s3_bucket.aws_s3_bucket.this bucket-name`

### 2. Versioning
- **What**: Enable S3 version history
- **Why**: Protects against accidental deletion
- **Impact**: Previous versions recoverable, storage costs increase

### 3. Encryption
- **What**: AES256 server-side encryption
- **Why**: Protects data at rest
- **Algorithm**: S3-managed keys (free, no KMS cost)

### 4. Public Access Blocking
- **What**: 4-layer defense against public exposure
- **Why**: Security hardening, compliance
- **Layers**:
  1. Block ACL-based public access
  2. Block policy-based public access
  3. Ignore existing public ACLs
  4. Restrict all public bucket access

### 5. Tagging
- **What**: Resource metadata
- **Why**: Cost tracking, organization, compliance
- **Merged from**:
  - User tags (this variable)
  - Module defaults (Name)
  - Provider defaults (Project, ManagedBy)

---

## Module Design Principles

### 1. Reusability
- No hardcoded values (everything is a variable)
- Works for dev, staging, prod without modification
- Single module = consistent configuration

### 2. Security First
- Encryption always enabled
- Public access always blocked
- Versioning always enabled
- No configuration options to disable security

### 3. Composability
- Clear inputs (variables) and outputs
- Integrates with other resources via outputs
- Designed for module composition

### 4. Maintainability
- Single responsibility (S3 bucket management)
- Comprehensive documentation
- Clear naming conventions
- Professional comments explaining WHY

---

## File Structure

```
modules/s3_bucket/
├── main.tf
│   ├── aws_s3_bucket (imported bucket)
│   ├── aws_s3_bucket_versioning (always enabled)
│   ├── aws_s3_bucket_server_side_encryption_configuration (always AES256)
│   └── aws_s3_bucket_public_access_block (always fully blocked)
│
├── variables.tf
│   ├── bucket_name (required)
│   └── tags (optional)
│
└── outputs.tf
    ├── bucket_id (bucket name)
    ├── bucket_arn (ARN for IAM)
    └── versioning_enabled (true/false)
```

---

## Best Practices

### ✅ Do

- ✅ Always provide `bucket_name` (required input)
- ✅ Use outputs for cross-resource references
- ✅ Let provider handle Project/ManagedBy tags
- ✅ Use module for all S3 buckets (consistency)
- ✅ Keep bucket_name descriptive (identify purpose/env)

### ❌ Don't

- ❌ Don't hardcode bucket names in code
- ❌ Don't disable security features (encryption, versioning, access blocking)
- ❌ Don't commit terraform.tfvars (use .example)
- ❌ Don't create bucket manually (use module)
- ❌ Don't change resource names from "this" (breaks state)

---

## Common Use Cases

### Use Case 1: Application Data Storage
```hcl
module "app_bucket" {
  source      = "../../modules/s3_bucket"
  bucket_name = "myapp-data-dev-055255093542-ap-south-1"
  tags = {
    Application = "myapp"
    Environment = "dev"
  }
}

# Pass to application via outputs
bucket_name = module.app_bucket.bucket_id
```

### Use Case 2: IAM Policy Configuration
```hcl
resource "aws_iam_role_policy" "s3_access" {
  name   = "s3-access"
  role   = aws_iam_role.app.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Resource = [
          module.s3_bucket.bucket_arn,
          "${module.s3_bucket.bucket_arn}/*"
        ]
      }
    ]
  })
}
```

### Use Case 3: Multiple Environments
```hcl
# environments/dev/main.tf
module "s3_bucket" {
  source      = "../../modules/s3_bucket"
  bucket_name = var.bucket_name  # "my-app-dev"
  tags = {
    Environment = "dev"
  }
}

# environments/prod/main.tf
module "s3_bucket" {
  source      = "../../modules/s3_bucket"
  bucket_name = var.bucket_name  # "my-app-prod"
  tags = {
    Environment = "prod"
  }
}
```

---

## Terraform Requirements

- **Terraform**: >= 1.5
- **AWS Provider**: ~> 5.0
- **AWS Account**: Active AWS account with S3 permissions

---

## Version History

### v1.0.0 (2026-07-22)
- Initial release
- S3 bucket import support
- Versioning, encryption, public access blocking
- Professional documentation
- HashiCorp best practices

---

## License

See main project LICENSE

---

## Support

For issues or questions:
1. Check main [README.md](../../README.md)
2. Review Terraform AWS provider [documentation](https://registry.terraform.io/providers/hashicorp/aws/latest)
3. Check AWS S3 [documentation](https://docs.aws.amazon.com/s3/)
