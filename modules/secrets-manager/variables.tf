variable "name_prefix" {
  description = "Prefix used for the secret name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]*$", var.name_prefix))
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

variable "secret_name" {
  description = "Application secret name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9/_+=.@-]+$", var.secret_name))
    error_message = "secret_name contains unsupported characters."
  }
}

variable "kms_key_arn" {
  description = "Customer-managed KMS key ARN used to encrypt the secret."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]+$", var.kms_key_arn))
    error_message = "kms_key_arn must be a valid KMS key ARN."
  }
}

variable "description" {
  description = "Description of the secret. Must not contain sensitive values."
  type        = string
  default     = null
}

variable "recovery_window_in_days" {
  description = "Number of days before a deleted secret is permanently removed."
  type        = number
  default     = 30

  validation {
    condition = (
      var.recovery_window_in_days == 0 ||
      (
        var.recovery_window_in_days >= 7 &&
        var.recovery_window_in_days <= 30
      )
    )

    error_message = "recovery_window_in_days must be 0 or between 7 and 30."
  }
}

variable "enable_rotation" {
  description = "Enable Secrets Manager rotation."
  type        = bool
  default     = false
}

variable "rotation_lambda_arn" {
  description = "ARN of the Lambda function used for secret rotation."
  type        = string
  default     = null
}

variable "rotation_days" {
  description = "Number of days between secret rotations."
  type        = number
  default     = 30

  validation {
    condition     = var.rotation_days >= 1
    error_message = "rotation_days must be at least 1."
  }
}

variable "tags" {
  description = "Additional tags for the secret."
  type        = map(string)
  default     = {}
}