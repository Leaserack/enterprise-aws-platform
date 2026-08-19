locals {
  secret_name = "${var.name_prefix}/${var.environment}/${var.secret_name}"

  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Component   = "secrets-manager"
    },
    var.tags
  )
}