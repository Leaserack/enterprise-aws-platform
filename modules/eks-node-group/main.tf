locals {
  node_group_name = var.node_group_name != null ? var.node_group_name : (
    "${var.name_prefix}-${var.environment}-system"
  )

  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Component   = "eks-node-group"
      Cluster     = var.cluster_name
      NodeGroup   = local.node_group_name
    },
    var.tags
  )
}

# ============================================================
# EKS MANAGED NODE GROUP
# ============================================================

resource "aws_eks_node_group" "this" {
  cluster_name    = var.cluster_name
  node_group_name = local.node_group_name
  node_role_arn   = var.node_role_arn

  subnet_ids = var.subnet_ids

  # ==========================================================
  # NODE IMAGE
  # ==========================================================

  ami_type = var.ami_type

  # ==========================================================
  # CAPACITY
  # ==========================================================

  capacity_type = var.capacity_type

  instance_types = var.instance_types

  # ==========================================================
  # ROOT VOLUME
  # ==========================================================

  disk_size = var.disk_size

  # ==========================================================
  # SCALING
  # ==========================================================

  scaling_config {
    min_size     = var.min_size
    desired_size = var.desired_size
    max_size     = var.max_size
  }

  # ==========================================================
  # ROLLING UPDATE
  # ==========================================================

  update_config {
    max_unavailable = var.update_max_unavailable
  }

  # ==========================================================
  # KUBERNETES LABELS
  # ==========================================================

  labels = var.labels

  # ==========================================================
  # TAGS
  # ==========================================================

  tags = merge(
    local.common_tags,
    {
      Name = local.node_group_name
    }
  )

  # ==========================================================
  # SAFETY VALIDATIONS
  # ==========================================================

  lifecycle {
    precondition {
      condition = (
        var.min_size <= var.desired_size &&
        var.desired_size <= var.max_size
      )

      error_message = "Scaling must satisfy min_size <= desired_size <= max_size."
    }

    precondition {
      condition = length(var.subnet_ids) >= 2

      error_message = "EKS managed node group must span at least two subnets."
    }

    precondition {
      condition = alltrue([
        for subnet_id in var.subnet_ids :
        length(trimspace(subnet_id)) > 0
      ])

      error_message = "subnet_ids cannot contain empty values."
    }
  }
}