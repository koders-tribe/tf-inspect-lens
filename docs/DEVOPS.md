# DevOps setup: Inspect Lens Terraform → application CD

This is the runbook for wiring [tf-inspect-lens](https://github.com/koders-tribe/tf-inspect-lens) to [inspect-lens-be](https://github.com/koders-tribe/inspect-lens-be).

The backend CD workflow (`.github/workflows/cd.yml`) is **off** until placeholders are gone and `CD_ENABLED=true`. It builds two images, pushes to ECR, and deploys to EC2 with **SSM** (no SSH).

## Ownership

| Lives in tf-inspect-lens | Lives in inspect-lens-be |
| --- | --- |
| VPC, RDS, S3, SES, ECR, IAM, OIDC, EC2, ALB, Secrets Manager | FastAPI, Alembic, `deploy/ec2/`, `app.env.example` |
| GitHub OIDC IAM roles | GitHub Actions workflows and GitHub variables |

Analyzer **code** stays in `inspect-image-analyzer`. Analyzer **ECR repo** is created here.

## Object keys the API already writes

- `orgs/{org_id}/findings/photos/...`
- `orgs/{org_id}/quotation-agreements/...`
- `orgs/{org_id}/inspection-reports/...`

S3 CORS must allow the **frontend origin** for `GET`, `PUT`, `HEAD`. Bucket stays private; the API mints presigned URLs (SigV4, virtual-hosted).

## After `terraform apply`

### 1. GitHub repo variables (`inspect-lens-be` → Settings → Variables)

Copy `terraform output github_actions_handoff`:

| Variable | Source |
| --- | --- |
| `AWS_REGION` | `ap-south-1` |
| `AWS_ACCOUNT_ID` | `055255093542` |
| `ECR_REPOSITORY` | `inspect-lens-be` |
| `ECR_ANALYZER_REPOSITORY` | `inspect-image-analyzer` |
| `AWS_ROLE_ARN` | output `github_build_role_arn` |
| `CD_ENABLED` | `false` until a staging deploy works |

### 2. GitHub Environments `staging` and `production`

Create both. Production: required reviewers; deploy branches tags `v*` and `main`.

| Variable | Source |
| --- | --- |
| `AWS_DEPLOY_ROLE_ARN` | output `github_deploy_role_arn` |
| `EC2_DEPLOY_PATH` | `/opt/inspect-lens-be` |
| `EC2_INSTANCE_IDS` **or** `EC2_TARGET_TAG_KEY=Name` + `EC2_TARGET_TAG_VALUE` | output `ec2_instance_id` / instance Name tag |
| `APP_HEALTHCHECK_URL` | output `app_healthcheck_url` (ALB) |
| `APP_PUBLIC_URL` | public API URL |

### 3. GitHub secret

`ANALYZER_REPO_TOKEN` — PAT that can clone `inspect-image-analyzer` if that repo is private.

### 4. On the EC2 host

1. Confirm SSM agent is Online.
2. Copy `inspect-lens-be/deploy/ec2/` to `EC2_DEPLOY_PATH`.
3. `chmod +x deploy.sh`.
4. Write `app.env` and `analyzer.env` from Secrets Manager. `ANALYZER_TOKEN_API_KEY` must equal analyzer `TOKEN_ENDPOINT_API_KEY`.
5. Do **not** open SSH 22 for CD.

`app.env` (never GitHub):

```bash
APP_ENV=prod
DATABASE_URL=   # from secret inspect-lens-<env>/database-url
JWT_SECRET_KEY=
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
S3_BUCKET=
S3_REGION=ap-south-1
SES_REGION=ap-south-1
EMAIL_SENDER=   # must be a verified SES identity
GOOGLE_API_KEY=
ANALYZER_SERVICE_URL=http://inspect-image-analyzer:5000
ANALYZER_TOKEN_API_KEY=
ANALYZER_MOCK=false
PASSWORD_RESET_BASE_URL=https://<frontend>/reset-password
EMAIL_VERIFICATION_BASE_URL=https://<frontend>/verify-email
```

### 5. SES

- Verify domain or mailbox.
- Request **production access** (leave sandbox). Recipients are real customers.
- `MOCK_EMAIL` must stay false in production.

### 6. Turn CD on

1. `workflow_dispatch` to **staging** on `inspect-lens-be`.
2. If green, set `CD_ENABLED=true`.
3. Production deploys from tags `v*.*.*` after CI is green.

## What not to do

- Do not attach `AmazonS3FullAccess` or `AmazonSESFullAccess` to the app user.
- Do not make the S3 bucket public.
- Do not run Postgres on the EC2 instance.
- Do not generate IAM access keys in Terraform.
- Do not set `CD_ENABLED=true` while GitHub variables still contain `REPLACE_ME`.
