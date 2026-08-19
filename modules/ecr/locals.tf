locals {
  repository_name = "${var.name_prefix}-${var.environment}-${var.repository_name}"

  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Component   = "ecr"
    },
    var.tags
  )
}