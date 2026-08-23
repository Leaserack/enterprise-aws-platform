locals {
  node_group_name = "${var.name_prefix}-${var.node_group_name}"

  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Component   = "eks-node-group"
    },
    var.tags
  )
}