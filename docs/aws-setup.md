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

## Free-plan accounts (SCP)

An AWS free-plan account is a member of an AWS-managed organization. A service control policy (SCP) there denies some IAM actions, whatever your own permissions are. The error looks like:

```
AccessDenied ... not authorized to perform: iam:CreateGroup ... with an explicit deny in a service control policy
```

Tested on a real free-plan account:

| IAM action | Result |
| --- | --- |
| `iam:CreateGroup` | **Denied** |
| `iam:CreateUser` | Allowed |
| `iam:CreateRole` | Allowed |
| `iam:CreateInstanceProfile` | Allowed |
| `iam:AddRoleToInstanceProfile` | Allowed |
| `iam:PassRole` | Not tested yet; shows up in the compute phase (launching EC2 with the instance profile) |

So `personal.tfvars.example` sets `create_app_iam_user = false`:
- No app IAM user, group, membership or group policy attachments are created.
- The scoped S3 + SES policy (`<iam_user_name>-s3-ses`) is still created. With compute on, it is attached to the EC2 instance role.
- The API on the instance has to use the instance role instead of static keys (see Follow-ups).

**If an earlier apply already created the IAM user.** For example, the group failed after the user was created. After setting `create_app_iam_user = false`, the next plan should be:

```
# module.iam.aws_iam_user.this has moved to module.iam.aws_iam_user.this[0]
# module.iam.aws_iam_user.this[0] will be destroyed
Plan: 0 to add, 0 to change, 1 to destroy.
```

Check `terraform state list` first. **Do not apply** if the plan replaces (`-/+`) or destroys anything else, or adds resources you did not expect.

If the SCP also denies `iam:DeleteUser`, that destroy fails. Drop the user from state and leave it; it has no keys and no policies:

```bash
terraform state rm 'module.iam.aws_iam_user.this[0]'
```

### RDS backup retention is capped

Free-plan accounts also limit RDS. Creating the DB with the default 7-day backup retention fails:

```
FreeTierRestrictionError: The specified backup retention period exceeds the maximum available to free tier customers.
```

`personal.tfvars.example` sets `db_backup_retention_days = 1`. Use `0` (no automated backups) if 1 is also rejected. The default stays 7 for the company account.

If the failed apply already created the random password, the `database-url` secret and the DB subnet group, they stay in state. The next plan should only **add** the DB instance and the secret version: 2 to add, 0 to change, 0 to destroy.

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
   - With `create_app_iam_user = true`, the IAM user, group and membership only show "has moved to …[0]" notes, not changes.
   - **Stop if the plan shows any replace (`-/+`) or destroy** of S3, IAM, SES, RDS or EC2. That means a name or setting does not match the existing resource.

## Troubleshooting

| Error | Cause |
| --- | --- |
| `AWS account ID not allowed` | Credentials are for a different account than `account_id` in tfvars. |
| `No valid credential sources found` | Use the `export-credentials` fallback in section 1. |
| `Unsupported argument "use_lockfile"` | Terraform older than 1.10. |
| `You can't create this secret because a secret with this name is already scheduled for deletion` | An earlier destroy ran with a 30-day recovery window. Restore the secret, or force-delete it with `aws secretsmanager delete-secret --force-delete-without-recovery`. |
| `BucketAlreadyExists` | S3 bucket names are global; set `bucket_name` explicitly. |
| `not authorized to perform: iam:CreateGroup ... explicit deny in a service control policy` | Free-plan SCP. Set `create_app_iam_user = false` (see Free-plan accounts). |
| `not authorized to perform: iam:DeleteUser ... service control policy` | Free-plan SCP on the user's destroy. Run `terraform state rm 'module.iam.aws_iam_user.this[0]'`. |
| `FreeTierRestrictionError: The specified backup retention period exceeds the maximum available to free tier customers` | Free-plan RDS limit. Set `db_backup_retention_days = 1`, or `0` if 1 is also rejected. |
| `not authorized to perform: iam:PassRole` when creating the EC2 instance | Free-plan SCP may deny PassRole (untested). Compute cannot launch with an instance profile in that account. |

## Follow-ups

### inspect-lens-be: use the instance role instead of static keys

Separate ticket in `inspect-lens-be`; nothing here changes the app.

**Goal:** when `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` are not set, build boto3 clients without explicit keys. boto3 then uses the default credential chain, which on EC2 is the instance role. This is required where `create_app_iam_user = false` (free-plan accounts), and it lets the company account drop the IAM user later.

**Files that require static keys today** (`main`):

| File | What it does |
| --- | --- |
| `src/settings.py` | Defines the key settings |
| `src/auth/routes.py` (around line 64) | Passes explicit keys to boto3 |
| `src/routes/password_reset.py` (around line 31) | Passes explicit keys to boto3 |
| `src/routes/inspection_report_dependencies.py` (lines 84–94) | Raises "Set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY" if missing, then passes keys |
| `src/routes/quotation_agreement_dependencies.py` (lines 66–76) | Same as above |
| `src/services/pdf_storage_service.py` (around line 44) | Checks for the keys |

Also update the unit tests that assume keys, `.env.example`, `deploy/ec2/app.env.example` and `DEPLOYMENT.md`:
- `tests/unit/routes/test_inspection_report_dependencies.py`
- `tests/unit/routes/test_quotation_agreement_dependencies.py`
- `tests/unit/services/test_finding_photo_service.py`
- `tests/unit/services/test_pdf_storage_service.py`

**Changes:**
- Make the two key settings optional (default empty).
- Pass `aws_access_key_id` / `aws_secret_access_key` only when both are set. Otherwise create the client with just `region_name`.
- Remove the "Set AWS_ACCESS_KEY_ID…" hard failures.
- Always pass the region (`S3_REGION` / `SES_REGION`). The instance role does not provide one.
- Local development keeps working with `AWS_PROFILE` or with keys in `.env`.

**Caveats:**
- **Presigned URLs.** A URL signed with temporary credentials (the instance role) stops working when those credentials expire, even if `ExpiresIn` is longer. Instance-role credentials rotate every few hours, so keep `S3_PRESIGN_EXPIRY_SECONDS` and the PDF `expires_in` short (an hour or less). That is already the default for PDF downloads (3600).
- **IMDS.** The instance already uses IMDSv2 with `http_put_response_hop_limit = 2`, so containers can reach the role credentials. Do not lower it to 1.
- **Company account.** After the app uses the role there, set `create_app_iam_user = false`. Delete the user's access keys first: IAM refuses to delete a user that still has keys, and Terraform did not create them.
