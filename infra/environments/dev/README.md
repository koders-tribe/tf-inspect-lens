# Dev environment

Working directory: `infra/environments/dev` (not `terraform/environments/dev`).

Remote state: `s3://inspect-lens-terraform-state-055255093542/dev/terraform.tfstate` (`ap-south-1`, native lockfile).

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

See the [root README](../../../README.md) and [DevOps runbook](../../../docs/DEVOPS.md).

## Existing resources

If the demo bucket already exists, import it before apply:

```bash
terraform import module.s3_bucket.aws_s3_bucket.this inspect-lens-demo-dev-055255093542-ap-south-1-an
```

IAM user `inspect-lens-dev` and group `inspect-lens-s3-developers` may already exist; import them if apply fails on `EntityAlreadyExists`:

```bash
terraform import module.iam.aws_iam_user.this inspect-lens-dev
terraform import module.iam.aws_iam_group.this inspect-lens-s3-developers
```

## AWS CLI profile

```bash
aws sts get-caller-identity
# Account 055255093542
```
