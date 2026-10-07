# tf-inspect-lens

Terraform for **Inspect Lens** AWS infrastructure. Application code and deploy scripts live in [`inspect-lens-be`](https://github.com/koders-tribe/inspect-lens-be). The image analyzer lives in [`inspect-image-analyzer`](https://github.com/koders-tribe/inspect-image-analyzer).

Default region: **ap-south-1**. State bucket: `inspect-lens-terraform-state-055255093542`.

## What this repo owns

| AWS | Used by the API for |
| --- | --- |
| S3 | Photos (presigned PUT/GET), quotation PDFs, inspection-report PDFs |
| SES | Password reset, email verification, agreement PDF (`SendRawEmail`) |
| IAM user | Static keys in `app.env` (the API does not use the instance role yet) |
| ECR × 2 | `inspect-lens-be`, `inspect-image-analyzer` |
| GitHub OIDC roles | CD build (ECR push) and deploy (SSM) |
| VPC / RDS / EC2 / ALB | Optional; enable with feature flags when CD should go live |
| Secrets Manager | Placeholders for `app.env` / `analyzer.env` (not GitHub Actions) |

**Do not** put Terraform in `inspect-lens-be`. **Do not** put `DATABASE_URL`, JWT, Google, or LLM keys in GitHub Actions.

## Layout

```
infra/
  modules/           # reusable resources
  environments/dev/  # current stack (remote state key dev/terraform.tfstate)
```

Copy `environments/dev` to `environments/staging` or `prod` when you need a second stack. Change `backend.tf` `key` (for example `staging/terraform.tfstate`) and `environment` in tfvars.

## Quick start (existing S3 / IAM / SES)

```bash
cd infra/environments/dev
cp terraform.tfvars.example terraform.tfvars
# edit bucket_name, cors_allowed_origins, ses_emails / ses_domain

aws sts get-caller-identity
terraform init
terraform plan
terraform apply
terraform output github_actions_handoff
```

`terraform.tfvars` is gitignored.

If the app bucket already exists:

```bash
terraform import module.s3_bucket.aws_s3_bucket.this <BUCKET-NAME>
```

If this account already has the GitHub OIDC provider, set `create_github_oidc_provider = false`.

## Apply in this order

1. **S3 + IAM + SES** (always on). Add CORS origins so the frontend can upload. Create the IAM user access key **in the console**. Request SES production access.
2. **ECR + GitHub OIDC + Secrets** (on by default). Paste `github_actions_handoff` into `inspect-lens-be` GitHub variables. Leave `CD_ENABLED=false` until EC2 exists.
3. Set `enable_network = true`, apply VPC.
4. Set `enable_rds = true`, apply Postgres. Read `DATABASE_URL` from Secrets Manager onto the host.
5. Set `enable_compute = true` (optional `enable_alb`). Copy `inspect-lens-be/deploy/ec2/` to `EC2_DEPLOY_PATH`. Write `app.env` and `analyzer.env`. Confirm SSM Online.
6. Staging `workflow_dispatch` on `inspect-lens-be`. Then set `CD_ENABLED=true`.

See [docs/DEVOPS.md](docs/DEVOPS.md) for the full handoff to `inspect-lens-be`.

## Feature flags

| Variable | Default | Creates |
| --- | --- | --- |
| `enable_ecr` | true | Two ECR repositories |
| `enable_github_oidc` | true | OIDC provider + build/deploy roles |
| `enable_secrets` | true | Empty Secrets Manager shells |
| `enable_network` | false | VPC, subnets, SGs |
| `enable_nat_gateway` | false | Single NAT (private-subnet egress) |
| `enable_vpc_endpoints` | false | SSM/ECR/S3 endpoints |
| `enable_rds` | false | PostgreSQL + `DATABASE_URL` secret |
| `enable_compute` | false | EC2, instance profile, uploads EBS |
| `enable_alb` | false | ALB + `/health` target group |

RDS and EC2 require `enable_network = true`.

## IAM note

The previous example attached `AmazonS3FullAccess` and `AmazonSESFullAccess`. Those are **not** in `terraform.tfvars.example` anymore. The IAM module attaches a policy limited to `s3:...` on `orgs/*` and `ses:SendRawEmail` on verified identities. After apply, drop the managed FullAccess policies from the group if they are still attached from an older apply.

Access keys are **not** created in Terraform (they would land in state). Create them once in IAM and store them in `app.env` on the instance.

## Requirements

- Terraform >= 1.10 (S3 backend `use_lockfile`)
- AWS provider ~> 5.0
- Permission to manage S3, IAM, SES, ECR, VPC, RDS, EC2, SSM, Secrets Manager in account `055255093542`
