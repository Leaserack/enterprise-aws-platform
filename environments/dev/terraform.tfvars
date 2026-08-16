aws_region = "us-east-1"

environment = "dev"

name_prefix = "lr-saas"

vpc_cidr = "10.10.0.0/16"

availability_zones = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c"
]

public_subnet_cidrs = [
  "10.10.1.0/24",
  "10.10.2.0/24",
  "10.10.3.0/24"
]

private_subnet_cidrs = [
  "10.10.11.0/24",
  "10.10.12.0/24",
  "10.10.13.0/24"
]

enable_nat_gateway = true

single_nat_gateway = true

enable_s3_endpoint = true

enable_dynamodb_endpoint = true