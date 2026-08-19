variable "name_prefix" {
  description = "Prefix used for the ECR repository."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]*$", var.name_prefix))
    error_message = "name_prefix must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "project_name" {
  description = "Project name used for resource tagging."
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

variable "repository_name" {
  description = "Application repository name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9._/-]*$", var.repository_name))
    error_message = "repository_name contains unsupported characters."
  }
}

variable "kms_key_arn" {
  description = "ARN of the customer-managed KMS key used to encrypt the ECR repository."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]+$", var.kms_key_arn))
    error_message = "kms_key_arn must be a valid AWS KMS key ARN."
  }
}

variable "image_tag_mutability" {
  description = "ECR image tag mutability."
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  description = "Enable ECR image scanning on push."
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "Allow Terraform to delete the repository even when images exist."
  type        = bool
  default     = false
}

variable "untagged_image_expiration_days" {
  description = "Number of days to retain untagged images."
  type        = number
  default     = 7

  validation {
    condition     = var.untagged_image_expiration_days >= 1
    error_message = "untagged_image_expiration_days must be at least 1."
  }
}

variable "tagged_image_retention_count" {
  description = "Number of tagged images to retain."
  type        = number
  default     = 30

  validation {
    condition     = var.tagged_image_retention_count >= 1
    error_message = "tagged_image_retention_count must be at least 1."
  }
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}