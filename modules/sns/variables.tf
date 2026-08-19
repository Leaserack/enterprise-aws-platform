variable "project_name" {
  description = "Project name used for resource naming and tagging."
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

variable "topic_name" {
  description = "SNS topic purpose/name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.topic_name))
    error_message = "topic_name may contain only letters, numbers, hyphens, and underscores."
  }
}

variable "display_name" {
  description = "Optional SNS display name."
  type        = string
  default     = null
}

variable "kms_key_arn" {
  description = "Customer-managed KMS key ARN for SNS encryption."
  type        = string
  default     = null

  validation {
    condition = (
      var.kms_key_arn == null ||
      can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]+$", var.kms_key_arn))
    )

    error_message = "kms_key_arn must be a valid KMS key ARN."
  }
}

variable "fifo_topic" {
  description = "Whether to create a FIFO SNS topic."
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enable content-based deduplication for FIFO topics."
  type        = bool
  default     = false
}

variable "subscriptions" {
  description = "SNS subscriptions."
  type = map(object({
    protocol = string
    endpoint = string
  }))
  default = {}
}

variable "tags" {
  description = "Additional SNS tags."
  type        = map(string)
  default     = {}
}