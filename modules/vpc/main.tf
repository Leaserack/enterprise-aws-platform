locals {
  resource_prefix = "${var.name_prefix}-${var.environment}"
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${local.resource_prefix}-vpc"
    Project     = var.name_prefix
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}