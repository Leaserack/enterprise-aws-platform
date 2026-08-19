variable "name_prefix" {
  description = "Prefix used for security group names."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.name_prefix))
    error_message = "name_prefix contains unsupported characters."
  }
}

variable "project_name" {
  description = "Project or platform name used for tagging."
  type        = string
  default     = "lr-saas"
}

variable "environment" {
  description = "Environment name."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "vpc_id" {
  description = "VPC ID where the security groups will be created."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "vpc_id must be a valid AWS VPC ID."
  }
}

variable "create_cluster_sg" {
  description = "Create the EKS cluster security group."
  type        = bool
  default     = true
}

variable "create_node_sg" {
  description = "Create the EKS node security group."
  type        = bool
  default     = true
}

variable "create_alb_sg" {
  description = "Create the ALB security group."
  type        = bool
  default     = true
}

variable "create_app_sg" {
  description = "Create the application security group."
  type        = bool
  default     = true
}

variable "create_database_sg" {
  description = "Create the database security group."
  type        = bool
  default     = true
}

variable "create_pod_sg" {
  description = "Create the security group intended for sensitive EKS pods."
  type        = bool
  default     = true
}

variable "allowed_ingress_cidr_blocks" {
  description = "CIDR blocks allowed to access the ALB. Keep empty unless explicitly required."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for cidr in var.allowed_ingress_cidr_blocks :
      can(cidrhost(cidr, 0))
    ])
    error_message = "Every allowed_ingress_cidr_blocks value must be a valid CIDR."
  }
}

variable "alb_ingress_ports" {
  description = "TCP ports exposed by the ALB."
  type        = list(number)
  default     = [443]

  validation {
    condition = alltrue([
      for port in var.alb_ingress_ports :
      port >= 1 && port <= 65535
    ])
    error_message = "ALB ports must be between 1 and 65535."
  }
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}