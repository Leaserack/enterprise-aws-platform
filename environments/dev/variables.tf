variable "aws_region" {
  description = "AWS region for the DEV environment."
  type        = string

  default = "us-east-1"

  validation {
    condition     = var.aws_region == "us-east-1"
    error_message = "DEV must be deployed in us-east-1."
  }
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  default = "dev"

  validation {
    condition     = var.environment == "dev"
    error_message = "This configuration is only for the dev environment."
  }
}

variable "name_prefix" {
  description = "Platform resource naming prefix."
  type        = string

  default = "lr-saas"

  validation {
    condition = (
      can(regex("^[a-z0-9-]+$", var.name_prefix))
    )

    error_message = "name_prefix must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "vpc_cidr" {
  description = "DEV VPC CIDR."
  type        = string

  default = "10.10.0.0/16"
}

variable "availability_zones" {
  description = "DEV Availability Zones."
  type        = list(string)

  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]
}

variable "public_subnet_cidrs" {
  description = "DEV public subnet CIDRs."
  type        = list(string)

  default = [
    "10.10.1.0/24",
    "10.10.2.0/24",
    "10.10.3.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "DEV private subnet CIDRs."
  type        = list(string)

  default = [
    "10.10.11.0/24",
    "10.10.12.0/24",
    "10.10.13.0/24"
  ]
}

variable "enable_nat_gateway" {
  description = "Whether NAT Gateway should be created."
  type        = bool

  default = true
}

variable "single_nat_gateway" {
  description = "Use one NAT Gateway for DEV to reduce cost."
  type        = bool

  default = true
}

variable "enable_s3_endpoint" {
  description = "Enable S3 Gateway VPC endpoint."
  type        = bool

  default = true
}

variable "enable_dynamodb_endpoint" {
  description = "Enable DynamoDB Gateway VPC endpoint."
  type        = bool

  default = true
}