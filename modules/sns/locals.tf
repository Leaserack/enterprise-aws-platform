locals {
  topic_name = "${var.project_name}-${var.environment}-${var.topic_name}"

  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Component   = "sns"
    },
    var.tags
  )
}