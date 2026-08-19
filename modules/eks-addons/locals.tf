locals {
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Component   = "eks-addons"
      Cluster     = var.cluster_name
    },
    var.tags
  )
}