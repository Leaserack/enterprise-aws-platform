variable "name_prefix" {
  description = "Platform naming prefix."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name_prefix))
    error_message = "name_prefix must contain only lowercase letters, numbers, and hyphens."
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
    condition = contains(
      ["dev", "staging", "prod"],
      var.environment
    )

    error_message = "environment must be dev, staging, or prod."
  }
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "node_group_name" {
  description = "Logical node group name."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.node_group_name))
    error_message = "node_group_name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "node_role_arn" {
  description = "IAM role ARN used by the EKS managed node group."
  type        = string

  validation {
    condition = can(
      regex(
        "^arn:aws:iam::[0-9]{12}:role/.+$",
        var.node_role_arn
      )
    )

    error_message = "node_role_arn must be a valid IAM role ARN."
  }
}

variable "subnet_ids" {
  description = "Private subnet IDs where worker nodes will run."
  type        = list(string)

  validation {
    condition = (
      length(var.subnet_ids) >= 2 &&
      alltrue([
        for subnet_id in var.subnet_ids :
        can(regex("^subnet-[a-f0-9]+$", subnet_id))
      ])
    )

    error_message = "At least two valid private subnet IDs are required."
  }
}

variable "ami_type" {
  description = "EKS managed node group AMI type."
  type        = string
  default     = "AL2023_x86_64_STANDARD"

  validation {
    condition = contains(
      [
        "AL2023_x86_64_STANDARD",
        "AL2023_x86_64_NVIDIA",
        "AL2023_ARM_64_STANDARD"
      ],
      var.ami_type
    )

    error_message = "Unsupported EKS managed node group AMI type."
  }
}

variable "capacity_type" {
  description = "Node capacity type."
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
  description = "EC2 instance types for the node group."
  type        = list(string)
  default     = ["m7i.large"]

  validation {
    condition = (
      length(var.instance_types) > 0 &&
      alltrue([
        for instance_type in var.instance_types :
        length(instance_type) > 0
      ])
    )

    error_message = "At least one EC2 instance type must be specified."
  }
}

variable "disk_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 50

  validation {
    condition = (
      var.disk_size >= 20 &&
      var.disk_size <= 16384
    )

    error_message = "disk_size must be between 20 and 16384 GiB."
  }
}

variable "desired_size" {
  description = "Desired number of nodes."
  type        = number
  default     = 3

  validation {
    condition     = var.desired_size >= 1
    error_message = "desired_size must be at least 1."
  }
}

variable "min_size" {
  description = "Minimum number of nodes."
  type        = number
  default     = 3

  validation {
    condition     = var.min_size >= 1
    error_message = "min_size must be at least 1."
  }
}

variable "max_size" {
  description = "Maximum number of nodes."
  type        = number
  default     = 6

  validation {
    condition     = var.max_size >= 1
    error_message = "max_size must be at least 1."
  }
}

variable "update_max_unavailable" {
  description = "Maximum number of unavailable nodes during managed node group updates."
  type        = number
  default     = 1

  validation {
    condition     = var.update_max_unavailable >= 1
    error_message = "update_max_unavailable must be at least 1."
  }
}

variable "labels" {
  description = "Kubernetes labels applied to nodes."
  type        = map(string)
  default     = {}
}

variable "taints" {
  description = "Kubernetes taints applied to nodes."
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))

  default = []

  validation {
    condition = alltrue([
      for taint in var.taints :
      contains(
        [
          "NO_SCHEDULE",
          "NO_EXECUTE",
          "PREFER_NO_SCHEDULE"
        ],
        taint.effect
      )
    ])

    error_message = "Taint effect must be NO_SCHEDULE, NO_EXECUTE, or PREFER_NO_SCHEDULE."
  }
}

variable "tags" {
  description = "Additional node group tags."
  type        = map(string)
  default     = {}
}