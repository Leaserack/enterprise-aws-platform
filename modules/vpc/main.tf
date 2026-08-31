locals {
  resource_prefix = "${var.name_prefix}-${var.environment}"

  public_subnets = {
    for index, az in var.availability_zones :
    format("%02d", index + 1) => {
      az   = az
      cidr = var.public_subnet_cidrs[index]
    }
  }

  private_subnets = {
    for index, az in var.availability_zones :
    format("%02d", index + 1) => {
      az   = az
      cidr = var.private_subnet_cidrs[index]
    }
  }

  nat_gateway_count = var.enable_nat_gateway ? (
    var.single_nat_gateway ? 1 : length(var.availability_zones)
  ) : 0
}

data "aws_region" "current" {}

# =========================================================
# VPC
# =========================================================

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name        = "${local.resource_prefix}-vpc"
    Project     = var.name_prefix
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# =========================================================
# Internet Gateway
# =========================================================

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${local.resource_prefix}-igw"
    Project     = var.name_prefix
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# =========================================================
# Public Subnets
# =========================================================

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.value.az
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = true

  tags = {
    Name        = "${local.resource_prefix}-public-${each.key}"
    Tier        = "public"
    Project     = var.name_prefix
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# =========================================================
# Private Subnets
# =========================================================

resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.this.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr

  tags = {
    Name        = "${local.resource_prefix}-private-${each.key}"
    Tier        = "private"
    Project     = var.name_prefix
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# =========================================================
# Public Route Table
# =========================================================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${local.resource_prefix}-public-rt"
    Tier        = "public"
    Project     = var.name_prefix
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# =========================================================
# NAT Gateway Elastic IPs
# =========================================================

resource "aws_eip" "nat" {
  count = local.nat_gateway_count

  domain = "vpc"

  tags = {
    Name        = "${local.resource_prefix}-nat-eip-${format("%02d", count.index + 1)}"
    Project     = var.name_prefix
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# =========================================================
# NAT Gateways
# =========================================================

resource "aws_nat_gateway" "this" {
  count = local.nat_gateway_count

  allocation_id = aws_eip.nat[count.index].id

  subnet_id = var.single_nat_gateway ? (
    aws_subnet.public["01"].id
    ) : (
    aws_subnet.public[
      format("%02d", count.index + 1)
    ].id
  )

  depends_on = [
    aws_internet_gateway.this
  ]

  tags = {
    Name        = "${local.resource_prefix}-nat-${format("%02d", count.index + 1)}"
    Project     = var.name_prefix
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# =========================================================
# Private Route Tables
# =========================================================

resource "aws_route_table" "private" {
  for_each = {
    for index, az in var.availability_zones :
    az => format("%02d", index + 1)
  }

  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${local.resource_prefix}-private-${each.value}-rt"
    Tier        = "private"
    Project     = var.name_prefix
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# =========================================================
# Private NAT Routes
# =========================================================

resource "aws_route" "private_nat" {
  for_each = var.enable_nat_gateway ? {
    for index, az in var.availability_zones :
    az => index
  } : {}

  route_table_id = aws_route_table.private[each.key].id

  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = var.single_nat_gateway ? (
    aws_nat_gateway.this[0].id
    ) : (
    aws_nat_gateway.this[each.value].id
  )
}

# =========================================================
# Private Route Table Associations
# =========================================================

resource "aws_route_table_association" "private" {
  for_each = {
    for index, az in var.availability_zones :
    format("%02d", index + 1) => az
  }

  subnet_id = aws_subnet.private[each.key].id

  route_table_id = aws_route_table.private[
    each.value
  ].id
}

# =========================================================
# S3 Gateway VPC Endpoint
# =========================================================

resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    for route_table in aws_route_table.private :
    route_table.id
  ]

  tags = {
    Name        = "${local.resource_prefix}-s3-endpoint"
    Project     = var.name_prefix
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# =========================================================
# DynamoDB Gateway VPC Endpoint
# =========================================================

resource "aws_vpc_endpoint" "dynamodb" {
  count = var.enable_dynamodb_endpoint ? 1 : 0

  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.dynamodb"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    for route_table in aws_route_table.private :
    route_table.id
  ]

  tags = {
    Name        = "${local.resource_prefix}-dynamodb-endpoint"
    Project     = var.name_prefix
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}