# ============================================================
# EKS NODE GROUP VARIABLES
# ============================================================

variable "name_prefix" {
  description = "Resource name prefix"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "node_group_name" {
  description = "Base node group name"
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN used by EKS worker nodes"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for the node group"
  type        = list(string)
}

variable "ami_type" {
  description = "EKS managed node group AMI type"
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "capacity_type" {
  description = "Node group capacity type"
  type        = string
  default     = "ON_DEMAND"
}

variable "instance_types" {
  description = "EC2 instance types"
  type        = list(string)
  default     = ["m7i.large"]
}

variable "disk_size" {
  description = "Node root disk size in GiB"
  type        = number
  default     = 50
}

variable "min_size" {
  description = "Minimum node count"
  type        = number
  default     = 3
}

variable "desired_size" {
  description = "Desired node count"
  type        = number
  default     = 3
}

variable "max_size" {
  description = "Maximum node count"
  type        = number
  default     = 6
}

variable "update_max_unavailable" {
  description = "Maximum unavailable nodes during update"
  type        = number
  default     = 1
}

variable "labels" {
  description = "Kubernetes labels for the node group"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Additional AWS resource tags"
  type        = map(string)
  default     = {}
}