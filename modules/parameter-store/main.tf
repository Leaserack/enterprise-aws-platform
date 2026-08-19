resource "aws_ssm_parameter" "this" {
  name        = local.parameter_name
  description = var.description
  type        = var.parameter_type
  tier        = var.tier
  value       = var.value

  key_id = var.parameter_type == "SecureString" ? var.kms_key_id : null

  tags = local.common_tags

  lifecycle {
    precondition {
      condition = (
        var.parameter_type != "SecureString" ||
        var.kms_key_id != null
      )

      error_message = "kms_key_id must be provided when parameter_type is SecureString."
    }
  }
}