terraform {

  backend "s3" {

    bucket = "inspect-lens-terraform-state-055255093542"

    key = "dev/terraform.tfstate"

    region = "ap-south-1"

    encrypt = true

    use_lockfile = true

  }

}