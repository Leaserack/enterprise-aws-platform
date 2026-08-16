terraform {
  required_version = "= 1.15.8"

  backend "s3" {
    bucket       = "leaserack-enterprise-aws-platform-tfstate-381549359906"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.57.1"
    }
  }
}