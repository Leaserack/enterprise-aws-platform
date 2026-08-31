variable "project_name" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string

  validation {
    condition = contains(
      ["dev", "staging", "prod"],
      var.environment
    )

    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version."
  type        = string

  validation {
    condition = can(
      regex(
        "^[0-9]+\\.[0-9]+$",
        var.kubernetes_version
      )
    )

    error_message = "kubernetes_version must use MAJOR.MINOR format."
  }
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets used by EKS."
  type        = list(string)

  validation {
    condition = length(var.private_subnet_ids) >= 2

    error_message = "At least two private subnets are required."
  }
}

variable "cluster_role_arn" {
  description = "EKS control plane IAM role ARN."
  type        = string
}

variable "node_role_arn" {
  description = "EKS node IAM role ARN. Kept as an input for module compatibility."
  type        = string
}

variable "cluster_security_group_id" {
  description = "Optional existing EKS cluster security group."
  type        = string
  default     = null
}

variable "endpoint_private_access" {
  description = "Enable private EKS API endpoint."
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public EKS API endpoint."
  type        = bool
  default     = false
}

variable "public_access_cidrs" {
  description = "Allowed CIDRs for public EKS endpoint."
  type        = list(string)
  default     = []
}

variable "authentication_mode" {
  description = "EKS authentication mode."
  type        = string
  default     = "API"

  validation {
    condition = contains(
      ["API", "API_AND_CONFIG_MAP"],
      var.authentication_mode
    )

    error_message = "authentication_mode must be API or API_AND_CONFIG_MAP."
  }
}

variable "enabled_cluster_log_types" {
  description = "EKS control-plane log types."
  type        = set(string)

  default = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  validation {
    condition = alltrue([
      for log_type in var.enabled_cluster_log_types :
      contains(
        [
          "api",
          "audit",
          "authenticator",
          "controllerManager",
          "scheduler"
        ],
        log_type
      )
    ])

    error_message = "Invalid EKS control-plane log type."
  }
}

variable "cluster_encryption_key_arn" {
  description = "KMS key ARN used to encrypt Kubernetes secrets."
  type        = string
}

variable "tags" {
  description = "Additional EKS tags."
  type        = map(string)
  default     = {}
}