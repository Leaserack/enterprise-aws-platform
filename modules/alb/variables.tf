variable "project_name" {
  description = "Project name used for tagging."
  type        = string
  default     = "lr-saas"
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging, or prod."
  }
}

variable "vpc_id" {
  description = "VPC ID where load balancers will be deployed."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs used by internet-facing ALBs."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "At least two public subnets are required for an internet-facing ALB."
  }
}

variable "internal_subnet_ids" {
  description = "Private subnet IDs used by internal ALBs."
  type        = list(string)
  default     = []
}

variable "create_security_group" {
  description = "Whether Terraform should create the ALB security group."
  type        = bool
  default     = true
}

variable "security_group_id" {
  description = "Existing ALB security group ID."
  type        = string
  default     = null
}

variable "allowed_ingress_cidrs" {
  description = "CIDRs allowed to access the ALB."
  type        = list(string)
  default     = []
}

variable "enable_http" {
  description = "Whether HTTP port 80 is allowed."
  type        = bool
  default     = false
}

variable "enable_https" {
  description = "Whether HTTPS port 443 is allowed."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional ALB tags."
  type        = map(string)
  default     = {}
}