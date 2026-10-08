# tf-inspect-lens

Terraform for **Inspect Lens** AWS infrastructure. Application code and deploy scripts live in [`inspect-lens-be`](https://github.com/koders-tribe/inspect-lens-be). The image analyzer lives in [`inspect-image-analyzer`](https://github.com/koders-tribe/inspect-image-analyzer).

The stack is account-independent: account, region, state bucket and names come from per-account files in `infra/environments/dev/config/`. Setup for a new account (personal practice or company) is in [docs/aws-setup.md](docs/aws-setup.md).

## What this repo owns

| AWS | Used by the API for |
| --- | --- |
| S3 | Photos (presigned PUT/GET), quotation PDFs, inspection-report PDFs |
| SES | Password reset, email verification, agreement PDF (`SendRawEmail`) |
| IAM user | Static keys in `app.env` (the API does not use the instance role yet; the EC2 role already has the same scoped policy) |
| ECR × 2 | `inspect-lens-be`, `inspect-image-analyzer` |
| GitHub OIDC roles | CD build (ECR push) and deploy (SSM) |
| VPC / RDS / EC2 / ALB | Optional; enable with feature flags when CD should go live |
| Secrets Manager | Placeholders for `app.env` / `analyzer.env` (not GitHub Actions) |

**Do not** put Terraform in `inspect-lens-be`. **Do not** put `DATABASE_URL`, JWT, Google, or LLM keys in GitHub Actions.

## Layout

```
infra/
  bootstrap/                # once per account: creates the remote-state bucket (local state)
  modules/                  # reusable resources
  environments/dev/         # current stack (remote state key dev/terraform.tfstate)
    config/                 # per-account backend-*.hcl and *.tfvars (copy the .example files)
    tests/                  # terraform test with mocked providers (no AWS)
```

Copy `environments/dev` to `environments/staging` or `prod` when you need a second stack; see [infra/environments/README.md](infra/environments/README.md).

## Quick start (company account, existing S3 / IAM / SES)

```bash
cd infra/environments/dev
cp config/backend-company.hcl.example config/backend-company.hcl   # fill bucket / region
cp config/company.tfvars.example config/company.tfvars             # fill account_id, region, bucket_name

aws sts get-caller-identity
terraform init -reconfigure -backend-config=config/backend-company.hcl
terraform plan  -var-file=config/company.tfvars
terraform apply -var-file=config/company.tfvars
terraform output github_actions_handoff
```

Real `config/*.hcl` and `*.tfvars` files are gitignored. `bucket_name` must be set explicitly for an existing bucket: left unset, the name is computed and Terraform would plan to replace the bucket.

For a personal practice account, start with [docs/aws-setup.md](docs/aws-setup.md).

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
| `enable_eip` | false | Elastic IP on the app instance |
| `enable_public_http` | false | App port open to the internet over plain HTTP, no ALB (practice only) |
| `allow_destroy` | false | Lets destroy remove non-empty S3/ECR; RDS without final snapshot or deletion protection |
| `create_app_iam_user` | true | App IAM user + group for static keys. `false` (free-plan accounts): only the scoped policy, attached to the EC2 role |

RDS and EC2 require `enable_network = true`.

The EC2 instance ignores AMI and `user_data` changes after creation, so a new AMI or a `user_data` fix only reaches a new instance. Replace the instance on purpose to pick them up (`terraform apply -replace='module.compute[0].aws_instance.this'`).

## IAM note

The previous example attached `AmazonS3FullAccess` and `AmazonSESFullAccess`. Those are **not** in `config/company.tfvars.example` anymore. The IAM module attaches a policy limited to `s3:...` on `orgs/*` and `ses:SendRawEmail` on verified identities. After apply, drop the managed FullAccess policies from the group if they are still attached from an older apply.

Access keys are **not** created in Terraform (they would land in state). Create them once in IAM and store them in `app.env` on the instance.

The IAM user and group are optional (`create_app_iam_user`). AWS free-plan accounts deny `iam:CreateGroup` through an organization SCP, so the personal example turns them off. The scoped policy is still created and attached to the EC2 instance role. The API needs a change in `inspect-lens-be` to use that role instead of static keys; see Follow-ups in [docs/aws-setup.md](docs/aws-setup.md).

## Requirements

- Terraform >= 1.10 (S3 backend `use_lockfile`)
- AWS provider ~> 5.0
- Permission to manage S3, IAM, SES, ECR, VPC, RDS, EC2, SSM, Secrets Manager in the target account (`account_id` in tfvars; the provider refuses any other account)

## Checks without AWS

```bash
terraform fmt -check -recursive infra
cd infra/environments/dev && terraform init -backend=false && terraform validate && terraform test
cd ../../bootstrap      && terraform init -backend=false && terraform validate && terraform test
```

`terraform test` plans against mocked providers, so it needs no credentials and makes no AWS calls.
