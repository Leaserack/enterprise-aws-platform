variable "project_name" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "cluster_version" {
  description = "EKS Kubernetes version."
  type        = string
}

variable "vpc_cni_version" {
  description = "VPC CNI add-on version. Null lets EKS choose a compatible version."
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
  description = "EBS CSI add-on version."
  type        = string
  default     = null
}

variable "enable_ebs_csi" {
  description = "Enable the EBS CSI add-on."
  type        = bool
  default     = false
}

variable "resolve_conflicts_on_create" {
  description = "Conflict resolution when creating an add-on."
  type        = string
  default     = "OVERWRITE"

  validation {
    condition = contains(
      ["NONE", "OVERWRITE", "PRESERVE"],
      var.resolve_conflicts_on_create
    )

    error_message = "Invalid add-on create conflict resolution."
  }
}

variable "resolve_conflicts_on_update" {
  description = "Conflict resolution when updating an add-on."
  type        = string
  default     = "OVERWRITE"

  validation {
    condition = contains(
      ["NONE", "OVERWRITE", "PRESERVE"],
      var.resolve_conflicts_on_update
    )

    error_message = "Invalid add-on update conflict resolution."
  }
}

variable "service_account_role_arns" {
  description = "Optional IAM roles for EKS add-ons."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Additional tags."
  type        = map(string)
  default     = {}
}