resource "aws_secretsmanager_secret" "this" {
  name                    = local.secret_name
  description             = var.description
  kms_key_id              = var.kms_key_arn
  recovery_window_in_days = var.recovery_window_in_days

  tags = local.common_tags
}

resource "aws_secretsmanager_secret_rotation" "this" {
  count = var.enable_rotation ? 1 : 0

  secret_id           = aws_secretsmanager_secret.this.id
  rotation_lambda_arn = var.rotation_lambda_arn

  rotation_rules {
    automatically_after_days = var.rotation_days
  }

  lifecycle {
    precondition {
      condition     = var.rotation_lambda_arn != null
      error_message = "rotation_lambda_arn must be provided when enable_rotation is true."
    }
  }
}