variable "name_prefix" {
  description = "Prefix used for KMS resource names."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.name_prefix))
    error_message = "name_prefix contains unsupported characters."
  }
}

variable "project_name" {
  description = "Project name used for tagging."
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

variable "purpose" {
  description = "Purpose of the KMS key, such as eks, data, secrets, logs, or backup."
  type        = string

  validation {
    condition = contains(
      ["eks", "data", "secrets", "logs", "backup", "s3"],
      var.purpose
    )

    error_message = "purpose must be one of: eks, data, secrets, logs, backup, s3."
  }
}

variable "description" {
  description = "Description of the KMS key. Do not place confidential information here."
  type        = string

  validation {
    condition     = length(var.description) <= 8192
    error_message = "description must be 8192 characters or fewer."
  }
}

variable "enable_key_rotation" {
  description = "Enable automatic KMS key rotation."
  type        = bool
  default     = true
}

variable "rotation_period_in_days" {
  description = "Automatic rotation period in days. Leave null for the AWS default."
  type        = number
  default     = null

  validation {
    condition = var.rotation_period_in_days == null || (
      var.rotation_period_in_days >= 90 &&
      var.rotation_period_in_days <= 2560
    )

    error_message = "rotation_period_in_days must be null or between 90 and 2560 days."
  }
}

variable "deletion_window_in_days" {
  description = "Number of days before a scheduled KMS key deletion."
  type        = number
  default     = 30

  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "deletion_window_in_days must be between 7 and 30."
  }
}

variable "enable_multi_region" {
  description = "Create the KMS key as a multi-Region primary key."
  type        = bool
  default     = false
}

variable "enable_key_policy" {
  description = "Whether to explicitly manage the KMS key policy."
  type        = bool
  default     = true
}

variable "key_administrator_role_arns" {
  description = "IAM role ARNs allowed to administer the KMS key."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for arn in var.key_administrator_role_arns :
      can(regex("^arn:aws:iam::[0-9]{12}:role/.+", arn))
    ])

    error_message = "key_administrator_role_arns must contain valid IAM role ARNs."
  }
}

variable "key_user_role_arns" {
  description = "IAM role ARNs allowed to use the KMS key."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for arn in var.key_user_role_arns :
      can(regex("^arn:aws:iam::[0-9]{12}:role/.+", arn))
    ])

    error_message = "key_user_role_arns must contain valid IAM role ARNs."
  }
}

variable "allowed_via_services" {
  description = "AWS services allowed to use the key through kms:ViaService."
  type        = list(string)
  default     = []
}

variable "prevent_destroy" {
  description = "Prevent Terraform from destroying the KMS key."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags for the KMS key."
  type        = map(string)
  default     = {}
}