variable "name_prefix" {
  description = "Base naming prefix for the workload."
  type        = string

  validation {
    condition = (
      length(var.name_prefix) >= 3 &&
      can(regex("^[a-z0-9-]+$", var.name_prefix))
    )

    error_message = "name_prefix must contain only lowercase letters, numbers, and hyphens."
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
  description = "CIDR block for the VPC."
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR."
  }
}

variable "availability_zones" {
  description = "Availability Zones for the VPC."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least two Availability Zones are required."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)

  validation {
    condition = (
      length(var.public_subnet_cidrs) ==
      length(var.availability_zones)
    )

    error_message = "public_subnet_cidrs must have one CIDR per Availability Zone."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)

  validation {
    condition = (
      length(var.private_subnet_cidrs) ==
      length(var.availability_zones)
    )

    error_message = "private_subnet_cidrs must have one CIDR per Availability Zone."
  }
}

variable "enable_nat_gateway" {
  description = "Whether NAT gateways should be created."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use one NAT gateway instead of one per Availability Zone."
  type        = bool
  default     = false
}