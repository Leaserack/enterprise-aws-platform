variable "name_prefix" {
  description = "Prefix used for the SSM parameter."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name_prefix))
    error_message = "name_prefix contains unsupported characters."
  }
}

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
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "parameter_name" {
  description = "SSM parameter name without the project/environment prefix."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._/-]+$", var.parameter_name))
    error_message = "parameter_name contains unsupported characters."
  }
}

variable "parameter_type" {
  description = "SSM parameter type."
  type        = string
  default     = "String"

  validation {
    condition = contains(
      ["String", "StringList", "SecureString"],
      var.parameter_type
    )

    error_message = "parameter_type must be String, StringList, or SecureString."
  }
}

variable "kms_key_id" {
  description = "KMS key ID or ARN used for SecureString parameters."
  type        = string
  default     = null
}

variable "value" {
  description = "Parameter value. Sensitive values should not be managed through Terraform."
  type        = string
  default     = null
  sensitive   = true
}

variable "tier" {
  description = "SSM parameter tier."
  type        = string
  default     = "Standard"

  validation {
    condition = contains(
      ["Standard", "Advanced", "Intelligent-Tiering"],
      var.tier
    )

    error_message = "tier must be Standard, Advanced, or Intelligent-Tiering."
  }
}

variable "description" {
  description = "Parameter description. Do not include sensitive information."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags for the SSM parameter."
  type        = map(string)
  default     = {}
}