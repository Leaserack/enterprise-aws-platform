locals {
  cluster_name = var.cluster_name

  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Component   = "eks"
      Cluster     = local.cluster_name
    },
    var.tags
  )
}