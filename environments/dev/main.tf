module "vpc" {
  source = "git::https://github.com/Leaserack/enterprise-aws-platform.git//modules/vpc?ref=vpc-v1.1.0"

  name_prefix = var.name_prefix
  environment = var.environment

  vpc_cidr = var.vpc_cidr

  availability_zones = var.availability_zones

  public_subnet_cidrs = var.public_subnet_cidrs

  private_subnet_cidrs = var.private_subnet_cidrs

  enable_nat_gateway = var.enable_nat_gateway

  single_nat_gateway = var.single_nat_gateway

  enable_s3_endpoint = var.enable_s3_endpoint

  enable_dynamodb_endpoint = var.enable_dynamodb_endpoint
}