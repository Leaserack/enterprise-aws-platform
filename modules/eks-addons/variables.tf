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
    error_message = "environment must be dev, staging, or prod."
  }
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "cluster_version" {
  description = "EKS Kubernetes cluster version."
  type        = string
}

variable "vpc_cni_version" {
  description = "VPC CNI add-on version."
  type        = string
  default     = null
}

variable "coredns_version" {
  description = "CoreDNS add-on version."
  type        = string
  default     = null
}

variable "kube_proxy_version" {
  description = "kube-proxy add-on version."
  type        = string
  default     = null
}

variable "ebs_csi_version" {
  description = "EBS CSI Driver add-on version."
  type        = string
  default     = null
}

variable "resolve_conflicts_on_create" {
  description = "Conflict resolution behavior when creating add-ons."
  type        = string
  default     = "OVERWRITE"

  validation {
    condition     = contains(["NONE", "OVERWRITE"], var.resolve_conflicts_on_create)
    error_message = "resolve_conflicts_on_create must be NONE or OVERWRITE."
  }
}

variable "resolve_conflicts_on_update" {
  description = "Conflict resolution behavior when updating add-ons."
  type        = string
  default     = "OVERWRITE"

  validation {
    condition     = contains(["NONE", "OVERWRITE", "PRESERVE"], var.resolve_conflicts_on_update)
    error_message = "resolve_conflicts_on_update must be NONE, OVERWRITE, or PRESERVE."
  }
}

variable "service_account_role_arns" {
  description = "IAM role ARNs for add-ons that require workload identity."
  type = object({
    vpc_cni = optional(string)
    ebs_csi = optional(string)
  })

  default = {}
}

variable "tags" {
  description = "Additional EKS add-on tags."
  type        = map(string)
  default     = {}
}