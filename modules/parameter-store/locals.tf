locals {
  parameter_name = "/${var.name_prefix}/${var.environment}/${var.parameter_name}"

  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Component   = "ssm-parameter-store"
    },
    var.tags
  )
}