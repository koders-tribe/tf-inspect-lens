Copy `../dev`, then change:

- `backend.tf` key to `staging/terraform.tfstate` (or `prod/terraform.tfstate`)
- `variable "environment"` default / tfvars to `staging` or `prod`
- `bucket_name`, IAM names, and feature flags so they do not collide with dev

Do not share one state file across environments.
