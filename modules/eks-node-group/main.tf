resource "aws_eks_node_group" "this" {
  cluster_name    = var.cluster_name
  node_group_name = local.node_group_name
  node_role_arn   = var.node_role_arn

  subnet_ids = var.subnet_ids

  ami_type       = var.ami_type
  capacity_type  = var.capacity_type
  instance_types = var.instance_types

  disk_size = var.disk_size

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  update_config {
    max_unavailable = var.update_max_unavailable
  }

  labels = var.labels

  dynamic "taint" {
    for_each = var.taints

    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = local.node_group_name
    }
  )

  lifecycle {
    precondition {
      condition = (
        var.min_size <= var.desired_size &&
        var.desired_size <= var.max_size
      )

      error_message = "Scaling configuration must satisfy min_size <= desired_size <= max_size."
    }

    precondition {
      condition     = length(var.subnet_ids) >= 2
      error_message = "The managed node group must span at least two subnets."
    }
  }
}