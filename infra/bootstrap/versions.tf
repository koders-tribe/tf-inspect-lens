# Creates the remote-state bucket for one AWS account. Uses local state on
# purpose: the bucket it creates cannot hold its own state before it exists.
# Run once per account; see docs/aws-setup.md.

terraform {
  # Matches infra/environments/dev, whose backend uses use_lockfile (1.10+).
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
