variable "name_prefix" {
  description = "Resource naming prefix."
  type        = string
}

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

variable "node_group_name" {
  description = "EKS managed node group name."
  type        = string
  default     = null
}

variable "node_role_arn" {
  description = "IAM role ARN for EKS worker nodes."
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for the managed node group."
  type        = list(string)

  validation {
    condition = length(var.subnet_ids) >= 2

    error_message = "At least two subnets are required."
  }
}

variable "ami_type" {
  description = "EKS managed node AMI type."
  type        = string
  default     = "AL2023_x86_64_STANDARD"

  validation {
    condition = contains(
      [
        "AL2023_x86_64_STANDARD",
        "AL2023_ARM_64_STANDARD"
      ],
      var.ami_type
    )

    error_message = "Unsupported AMI type for this module."
  }
}

variable "capacity_type" {
  description = "EKS node capacity type."
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition = contains(
      ["ON_DEMAND", "SPOT"],
      var.capacity_type
    )

    error_message = "capacity_type must be ON_DEMAND or SPOT."
  }
}

variable "instance_types" {
  description = "EC2 instance types."
  type        = list(string)

  validation {
    condition = length(var.instance_types) > 0

    error_message = "At least one instance type is required."
  }
}

variable "disk_size" {
  description = "Node root disk size in GiB."
  type        = number
  default     = 50

  validation {
    condition = var.disk_size >= 20

    error_message = "disk_size must be at least 20 GiB."
  }
}

variable "min_size" {
  description = "Minimum node count."
  type        = number
}

variable "desired_size" {
  description = "Desired node count."
  type        = number
}

variable "max_size" {
  description = "Maximum node count."
  type        = number
}

variable "update_max_unavailable" {
  description = "Maximum unavailable nodes during update."
  type        = number
  default     = 1

  validation {
    condition = var.update_max_unavailable >= 1

    error_message = "update_max_unavailable must be at least 1."
  }
}

variable "labels" {
  description = "Kubernetes labels for nodes."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Additional tags."
  type        = map(string)
  default     = {}
}