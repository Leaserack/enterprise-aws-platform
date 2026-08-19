resource "aws_cloudwatch_log_group" "this" {
  name              = "/${var.project_name}/${var.environment}/${var.log_group_name}"
  retention_in_days = var.retention_in_days
  log_group_class   = var.log_group_class
  kms_key_id        = var.kms_key_arn

  tags = merge(
    local.common_tags,
    {
      Name = "/${var.project_name}/${var.environment}/${var.log_group_name}"
    }
  )
}