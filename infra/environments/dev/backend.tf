# Partial backend: bucket, key, region, encrypt and use_lockfile come from a
# per-account file, e.g.
#   terraform init -backend-config=config/backend-personal.hcl
# See config/*.hcl.example and docs/aws-setup.md.

terraform {
  backend "s3" {}
}
