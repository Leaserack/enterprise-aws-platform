variable "project_name" {
  description = "Project name used for naming and tagging."
  type        = string
  default     = "lr-saas"
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
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
    condition     = can(regex("^[0-9]+\\.[0-9]+$", var.kubernetes_version))
    error_message = "kubernetes_version must use the format MAJOR.MINOR, for example 1.33."
  }
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by the EKS cluster and node groups."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "At least two private subnets are required for EKS."
  }
}

variable "cluster_role_arn" {
  description = "IAM role ARN assumed by the EKS control plane."
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN assumed by EKS managed nodes."
  type        = string
}

variable "cluster_security_group_id" {
  description = "Optional existing security group for the EKS cluster."
  type        = string
  default     = null
}

variable "endpoint_private_access" {
  description = "Enable private EKS API endpoint access."
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public EKS API endpoint access."
  type        = bool
  default     = false
}

variable "public_access_cidrs" {
  description = "CIDR ranges allowed to access the public EKS API endpoint."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for cidr in var.public_access_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "Every public_access_cidrs value must be a valid CIDR."
  }
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

    error_message = "Invalid EKS cluster log type."
  }
}

variable "cluster_encryption_key_arn" {
  description = "KMS key ARN used to encrypt Kubernetes secrets."
  type        = string
}

variable "access_entries" {
  description = "IAM principals allowed to access the EKS cluster."
  type = map(object({
    principal_arn     = string
    kubernetes_groups = optional(list(string), [])
    type              = optional(string, "STANDARD")

    policy_associations = optional(map(object({
      policy_arn = string

      access_scope = object({
        type       = string
        namespaces = optional(list(string), [])
      })
    })), {})
  }))

  default = {}
}

variable "addons" {
  description = "EKS managed add-ons to install."
  type = map(object({
    addon_version               = optional(string)
    resolve_conflicts_on_create = optional(string, "OVERWRITE")
    resolve_conflicts_on_update = optional(string, "OVERWRITE")
    service_account_role_arn    = optional(string)
  }))

  default = {}
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}