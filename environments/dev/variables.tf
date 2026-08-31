variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name."
  type        = string
  default     = "lr-saas"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"

  validation {
    condition = var.environment == "dev"

    error_message = "This configuration is for the dev environment."
  }
}

variable "name_prefix" {
  description = "Resource naming prefix."
  type        = string
  default     = "lr-saas"
}

variable "vpc_cidr" {
  description = "DEV VPC CIDR."
  type        = string
  default     = "10.10.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones."
  type        = list(string)

  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]

  validation {
    condition = length(var.availability_zones) == 3

    error_message = "DEV requires exactly three Availability Zones."
  }
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs."
  type        = list(string)

  validation {
    condition = (
      length(var.public_subnet_cidrs) ==
      length(var.availability_zones)
    )

    error_message = "One public subnet CIDR is required per AZ."
  }
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs."
  type        = list(string)

  validation {
    condition = (
      length(var.private_subnet_cidrs) ==
      length(var.availability_zones)
    )

    error_message = "One private subnet CIDR is required per AZ."
  }
}

variable "eks_cluster_name" {
  description = "EKS cluster name."
  type        = string
  default     = "lr-saas-dev-eks"
}

variable "eks_kubernetes_version" {
  description = "EKS Kubernetes version."
  type        = string
  default     = "1.33"

  validation {
    condition = can(
      regex(
        "^[0-9]+\\.[0-9]+$",
        var.eks_kubernetes_version
      )
    )

    error_message = "Use Kubernetes MAJOR.MINOR format."
  }
}