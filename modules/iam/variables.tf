variable "name_prefix" {
  description = "Prefix used for IAM resource names."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.name_prefix))
    error_message = "name_prefix contains unsupported characters."
  }
}

variable "environment" {
  description = "Environment name such as dev, staging, or prod."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "create_ec2_role" {
  description = "Whether to create the EC2 workload IAM role."
  type        = bool
  default     = true
}

variable "create_eks_node_role" {
  description = "Whether to create the EKS managed node group IAM role."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags for supported IAM resources."
  type        = map(string)
  default     = {}
}