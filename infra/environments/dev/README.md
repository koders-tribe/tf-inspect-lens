# Dev environment

Working directory: `infra/environments/dev` (not `terraform/environments/dev`).

Remote state: S3 backend with native lockfile, key `dev/terraform.tfstate`. The bucket and region come from `config/backend-<name>.hcl` (partial backend), so the same code serves any account.

```bash
cp config/backend-<name>.hcl.example config/backend-<name>.hcl   # personal | company
cp config/<name>.tfvars.example config/<name>.tfvars
terraform init -reconfigure -backend-config=config/backend-<name>.hcl
terraform plan  -var-file=config/<name>.tfvars
terraform apply -var-file=config/<name>.tfvars
```

A `terraform.tfvars` in this directory is still loaded automatically, on top of `-var-file`. Keep only one source of values per account.

See the [root README](../../../README.md), [AWS setup](../../../docs/aws-setup.md) and [DevOps runbook](../../../docs/DEVOPS.md).

## Existing resources

If the app bucket already exists, set `bucket_name` to its exact name in tfvars and import it before apply:

```bash
terraform import -var-file=config/company.tfvars module.s3_bucket.aws_s3_bucket.this <BUCKET-NAME>
```

IAM user `inspect-lens-dev` and group `inspect-lens-s3-developers` may already exist; import them if apply fails on `EntityAlreadyExists`:

```bash
terraform import -var-file=config/company.tfvars module.iam.aws_iam_user.this inspect-lens-dev
terraform import -var-file=config/company.tfvars module.iam.aws_iam_group.this inspect-lens-s3-developers
```

## AWS credentials

```bash
aws sts get-caller-identity
# Account must equal account_id in tfvars; the provider refuses any other account.
```
