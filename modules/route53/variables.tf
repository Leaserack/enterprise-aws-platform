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

variable "domain_name" {
  description = "Root DNS domain name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.domain_name))
    error_message = "domain_name must be a valid DNS domain."
  }
}

variable "create_zone" {
  description = "Whether to create the Route 53 hosted zone."
  type        = bool
  default     = true
}

variable "private_zone" {
  description = "Whether the hosted zone is private."
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID required for a private hosted zone."
  type        = string
  default     = null
}


variable "records" {
  description = "DNS records to create."
  type = map(object({
    type            = string
    ttl             = optional(number, 300)
    records         = optional(list(string), [])
    alias_name      = optional(string)
    alias_zone_id   = optional(string)
    evaluate_target = optional(bool, false)
  }))
  default = {}
}

variable "tags" {
  description = "Additional tags for Route 53 resources."
  type        = map(string)
  default     = {}
}