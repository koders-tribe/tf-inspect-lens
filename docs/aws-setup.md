# AWS setup: personal practice account → company account

The same Terraform code runs in any account. Everything account-specific lives in two gitignored files under `infra/environments/dev/config/`:

| File | Holds |
| --- | --- |
| `backend-<name>.hcl` | Where state lives: bucket, key, region |
| `<name>.tfvars` | What gets built: `account_id`, `aws_region`, names, feature flags |

`<name>` is `personal` or `company`. Start each from its `.example` file.

Requirements: Terraform >= 1.10, AWS CLI v2.

## 1. Credentials (personal account)

Create the profile once and check it:

```bash
aws login --profile inspect-personal          # region: ap-southeast-2
aws sts get-caller-identity --profile inspect-personal
```

Point Terraform at it with an environment variable. Do **not** set `aws_profile` in tfvars:

```bash
export AWS_PROFILE=inspect-personal
```

**Fallback.** If Terraform fails with "no valid credential sources" (the pinned AWS provider 5.x may not read `aws login` sessions), export short-lived keys instead:

```bash
unset AWS_PROFILE
eval "$(aws configure export-credentials --profile inspect-personal --format env)"
```

These keys expire; run the `eval` again when Terraform reports expired credentials. Unset `AWS_PROFILE` first: a named profile can take priority over the exported keys.

Whichever way you authenticate, the provider checks `allowed_account_ids = [account_id]` and stops if the credentials belong to another account.

## 2. State bucket (once per account)

Skip this in the company account: its state bucket already exists.

```bash
cd infra/bootstrap
cp terraform.tfvars.example terraform.tfvars      # account_id, aws_region
terraform init
terraform plan
terraform apply
terraform output -raw backend_config
```

Creates `inspect-lens-terraform-state-<account_id>-<region>`: versioned, encrypted, public access blocked, TLS-only, `prevent_destroy`.

The bootstrap's own state is a local `terraform.tfstate` (gitignored). If you lose it, nothing breaks. Run `terraform import aws_s3_bucket.state <bucket>`, plus the sub-resources, before changing the bootstrap again.

## 3. App stack (personal)

```bash
cd infra/environments/dev
cp config/backend-personal.hcl.example config/backend-personal.hcl   # bucket = bootstrap output
cp config/personal.tfvars.example config/personal.tfvars             # account_id, ses_emails

terraform init -reconfigure -backend-config=config/backend-personal.hcl
terraform plan  -var-file=config/personal.tfvars -out=tfplan
terraform apply tfplan
```

`tfplan` is gitignored. It can contain secret values; delete it after apply.

Apply in steps. Flip one flag in `personal.tfvars`, then plan and apply again:

1. **Defaults:** S3, IAM user/group, SES identities, ECR, Secrets Manager shells.
   - Click the SES verification mail.
   - A new account is in the SES sandbox, so recipients must be verified too.
2. **`enable_network = true`:** VPC and subnets. No NAT, ALB or VPC endpoints in practice.
3. **`enable_rds = true`:** Postgres `db.t4g.micro`, plus the `DATABASE_URL` secret (name in `terraform output app_env`).
4. **`enable_compute = true`:** a `t3.micro` with 2 GB swap, Elastic IP and the app port open over HTTP.
   - Wait until the instance is "Online" in SSM Fleet Manager.
   - Copy `inspect-lens-be/deploy/ec2/` to `/opt/inspect-lens-be`.
   - Write `app.env` from `terraform output app_env` and the secrets.
   - The API is then at `terraform output api_url`.

If the API and analyzer run out of memory, set `ec2_instance_type = "t3.small"`. That change stops and starts the instance; it does not replace it.

### AMI and user_data changes do not reach a running instance

`aws_instance` has `ignore_changes = [ami, user_data]`. Without it, every new Amazon Linux AMI release would replace the instance and lose its root disk. So:

- A fix to `user_data.sh.tftpl` (or a newer AMI) only applies to **new** instances.
- To pick it up, replace the instance on purpose:

  ```bash
  terraform apply -var-file=config/personal.tfvars -replace='module.compute[0].aws_instance.this'
  ```

  The uploads EBS volume is separate and is re-attached, not formatted again. The root disk and anything on it are lost. The instance ID changes (update `EC2_INSTANCE_IDS` if you use it), and so does the public IP unless `enable_eip` is on.

### Cost and teardown

These are rough monthly costs while running: EC2 `t3.micro` about $9, Elastic IP / public IPv4 about $3.60, RDS `db.t4g.micro` about $13 plus storage, Secrets Manager $0.40 per secret. NAT gateway, ALB and VPC endpoints are off on purpose.

Tear down when you are not practising:

```bash
terraform destroy -var-file=config/personal.tfvars
```

`allow_destroy = true` and `secret_recovery_window_days = 0` make this complete in one pass:
- non-empty S3 and ECR are deleted;
- RDS skips the final snapshot and deletion protection;
- secrets are deleted immediately, so the next apply can reuse their names.

The state bucket stays (`prevent_destroy`). It costs cents.

## 4. Switching to the company account

1. Switch credentials and check the account:

   ```bash
   unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
   export AWS_PROFILE=<company profile>
   aws sts get-caller-identity
   ```

2. Create `config/backend-company.hcl` and `config/company.tfvars` from the examples:
   - Copy the existing bucket name, `key = "dev/terraform.tfstate"` and the region **exactly**. A different key gives an empty state, and the next plan would try to create everything again.
   - Set `bucket_name` to the existing app bucket. If it is left unset, the computed name differs and Terraform plans to **replace** the bucket.

3. Re-initialise against the company state:

   ```bash
   terraform init -reconfigure -backend-config=config/backend-company.hcl
   ```

   Use `-reconfigure`, **never** `-migrate-state`. Migrating would copy the personal account's state into the company bucket.

4. Plan and read it before applying:

   ```bash
   terraform plan -var-file=config/company.tfvars
   ```

   - Expected in-place updates include the GitHub role trust and deploy policies, and the RDS deletion protection if RDS exists.
   - **Stop if the plan shows any replace (`-/+`) or destroy** of S3, IAM, SES, RDS or EC2. That means a name or setting does not match the existing resource.

## Troubleshooting

| Error | Cause |
| --- | --- |
| `AWS account ID not allowed` | Credentials are for a different account than `account_id` in tfvars. |
| `No valid credential sources found` | Use the `export-credentials` fallback in section 1. |
| `Unsupported argument "use_lockfile"` | Terraform older than 1.10. |
| `You can't create this secret because a secret with this name is already scheduled for deletion` | An earlier destroy ran with a 30-day recovery window. Restore the secret, or force-delete it with `aws secretsmanager delete-secret --force-delete-without-recovery`. |
| `BucketAlreadyExists` | S3 bucket names are global; set `bucket_name` explicitly. |
