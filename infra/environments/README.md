Copy `../dev`, then change:

- `key` in `config/backend-*.hcl` to `staging/terraform.tfstate` (or `prod/terraform.tfstate`)
- `environment` in tfvars to `staging` or `prod`
- `bucket_name`, IAM names, and feature flags so they do not collide with dev
- `allow_destroy = false` and `secret_recovery_window_days = 30` for anything that is not practice

The RDS settings follow `allow_destroy`: with `false` you get deletion protection and a final snapshot. Do not copy a practice tfvars to prod.

Do not share one state file across environments.
