variable "aws_region" {
  description = "AWS region for the DEV environment."
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
    condition     = var.environment == "dev"
    error_message = "This configuration is only for the dev environment."
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
  description = "Availability Zones for the DEV VPC."
  type        = list(string)

  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]
}

variable "eks_cluster_name" {
  description = "EKS cluster name."
  type        = string
  default     = "lr-saas-dev-eks"
}

variable "eks_kubernetes_version" {
  description = "Kubernetes version for EKS."
  type        = string
  default     = "1.33"
}