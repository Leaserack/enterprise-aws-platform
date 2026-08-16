variable "name_prefix" {
  description = "Base naming prefix for the platform."
  type        = string

  validation {
    condition = (
      length(var.name_prefix) >= 3 &&
      length(var.name_prefix) <= 30 &&
      can(regex("^[a-z0-9-]+$", var.name_prefix))
    )

    error_message = "name_prefix must contain 3-30 lowercase letters, numbers, or hyphens."
  }
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition = contains(
      ["dev", "stage", "prod"],
      var.environment
    )

    error_message = "environment must be one of: dev, stage, prod."
  }
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string

  validation {
    condition = (
      can(cidrhost(var.vpc_cidr, 0)) &&
      can(cidrnetmask(var.vpc_cidr))
    )

    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "availability_zones" {
  description = "Availability Zones used by the VPC."
  type        = list(string)

  validation {
    condition = (
      length(var.availability_zones) >= 2 &&
      length(var.availability_zones) <= 6
    )

    error_message = "availability_zones must contain between 2 and 6 Availability Zones."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets. One CIDR per Availability Zone."
  type        = list(string)

  validation {
    condition = (
      length(var.public_subnet_cidrs) ==
      length(var.availability_zones)
    )

    error_message = "public_subnet_cidrs must contain exactly one CIDR per Availability Zone."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets. One CIDR per Availability Zone."
  type        = list(string)

  validation {
    condition = (
      length(var.private_subnet_cidrs) ==
      length(var.availability_zones)
    )

    error_message = "private_subnet_cidrs must contain exactly one CIDR per Availability Zone."
  }
}

variable "enable_nat_gateway" {
  description = "Whether NAT gateways should be created."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Whether to create a single NAT gateway instead of one per Availability Zone."
  type        = bool
  default     = false
}

variable "enable_s3_endpoint" {
  description = "Whether to create an S3 Gateway VPC endpoint."
  type        = bool
  default     = true
}

variable "enable_dynamodb_endpoint" {
  description = "Whether to create a DynamoDB Gateway VPC endpoint."
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Whether DNS resolution is enabled in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Whether DNS hostnames are enabled in the VPC."
  type        = bool
  default     = true
}