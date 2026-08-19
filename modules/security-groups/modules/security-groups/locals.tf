locals {
  resource_prefix = "${var.name_prefix}-${var.environment}"

  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Component   = "security-groups"
    },
    var.tags
  )

  cluster_sg_name = "${local.resource_prefix}-eks-cluster-sg"
  node_sg_name    = "${local.resource_prefix}-eks-node-sg"
  alb_sg_name     = "${local.resource_prefix}-alb-sg"
  app_sg_name     = "${local.resource_prefix}-app-sg"
  db_sg_name      = "${local.resource_prefix}-db-sg"
  pod_sg_name     = "${local.resource_prefix}-pod-sg"
}