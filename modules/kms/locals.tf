locals {
  resource_prefix = "${var.name_prefix}-${var.environment}"

  key_name = "${local.resource_prefix}-${var.purpose}"

  alias_name = "alias/${local.resource_prefix}-${var.purpose}"

  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Component   = "kms"
      Purpose     = var.purpose
    },
    var.tags
  )

  key_administrator_arns = concat(
    var.key_administrator_role_arns,
    [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
    ]
  )
}