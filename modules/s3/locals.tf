locals {
  bucket_name = "${var.name_prefix}-${var.environment}-${var.bucket_purpose}-${data.aws_caller_identity.current.account_id}"

  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Component   = "s3"
      Purpose     = var.bucket_purpose
    },
    var.tags
  )
}