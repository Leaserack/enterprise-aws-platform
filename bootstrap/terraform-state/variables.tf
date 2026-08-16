variable "aws_region" {
  description = "Primary AWS region."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = var.aws_region == "us-east-1"
    error_message = "The primary AWS region must be us-east-1."
  }
}

variable "secondary_region" {
  description = "Secondary AWS region for disaster recovery."
  type        = string
  default     = "us-west-2"

  validation {
    condition     = var.secondary_region == "us-west-2"
    error_message = "The secondary AWS region must be us-west-2."
  }
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string

  validation {
    condition = (
      length(var.state_bucket_name) >= 3 &&
      length(var.state_bucket_name) <= 63 &&
      can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.state_bucket_name))
    )

    error_message = "The state bucket name must be a valid S3 bucket name."
  }
}