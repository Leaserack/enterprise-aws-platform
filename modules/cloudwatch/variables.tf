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

variable "log_group_name" {
  description = "CloudWatch log group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._/-]+$", var.log_group_name))
    error_message = "log_group_name contains unsupported characters."
  }
}

variable "retention_in_days" {
  description = "CloudWatch Logs retention period."
  type        = number
  default     = 30

  validation {
    condition = contains(
      [
        1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180,
        365, 400, 545, 731, 1095, 1827, 2192, 2557,
        2922, 3288, 3653
      ],
      var.retention_in_days
    )

    error_message = "retention_in_days must be a supported CloudWatch Logs retention value."
  }
}

variable "kms_key_arn" {
  description = "Optional customer-managed KMS key ARN."
  type        = string
  default     = null
}

variable "log_group_class" {
  description = "CloudWatch Logs log group class."
  type        = string
  default     = "STANDARD"

  validation {
    condition = contains(
      ["STANDARD", "INFREQUENT_ACCESS"],
      var.log_group_class
    )

    error_message = "log_group_class must be STANDARD or INFREQUENT_ACCESS."
  }
}

variable "tags" {
  description = "Additional CloudWatch tags."
  type        = map(string)
  default     = {}
}