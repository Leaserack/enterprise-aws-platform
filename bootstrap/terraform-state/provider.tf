provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "enterprise-aws-platform"
      ManagedBy   = "Terraform"
      Environment = "bootstrap"
      Region      = var.aws_region
    }
  }
}