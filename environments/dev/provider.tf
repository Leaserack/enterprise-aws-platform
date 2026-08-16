provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "lr-saas"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}