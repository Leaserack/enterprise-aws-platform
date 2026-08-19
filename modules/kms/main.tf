# ============================================================
# KMS CUSTOMER MANAGED KEY
# ============================================================

resource "aws_kms_key" "this" {
  description              = var.description
  deletion_window_in_days  = var.deletion_window_in_days
  enable_key_rotation      = var.enable_key_rotation
  multi_region             = var.enable_multi_region
  rotation_period_in_days  = var.rotation_period_in_days

  policy = var.enable_key_policy ? data.aws_iam_policy_document.key_policy.json : null

  tags = merge(
    local.common_tags,
    {
      Name = local.key_name
    }
  )

}

# ============================================================
# KMS ALIAS
# ============================================================

resource "aws_kms_alias" "this" {
  name          = local.alias_name
  target_key_id = aws_kms_key.this.key_id
}