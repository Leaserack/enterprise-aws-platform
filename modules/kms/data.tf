data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "key_policy" {
  statement {
    sid    = "EnableAccountRootPermissions"
    effect = "Allow"

    actions = [
      "kms:*"
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    resources = [
      "*"
    ]
  }

  dynamic "statement" {
    for_each = length(local.key_administrator_arns) > 0 ? [1] : []

    content {
      sid    = "AllowKeyAdministrators"
      effect = "Allow"

      actions = [
        "kms:CreateGrant",
        "kms:DescribeKey",
        "kms:EnableKey",
        "kms:DisableKey",
        "kms:EnableKeyRotation",
        "kms:GetKeyPolicy",
        "kms:GetKeyRotationStatus",
        "kms:ListAliases",
        "kms:ListGrants",
        "kms:ListKeyPolicies",
        "kms:PutKeyPolicy",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:UpdateAlias",
        "kms:UpdateKeyDescription",
        "kms:UpdateKeyRotationStatus"
      ]

      principals {
        type        = "AWS"
        identifiers = local.key_administrator_arns
      }

      resources = [
        "*"
      ]
    }
  }

  dynamic "statement" {
    for_each = length(var.key_user_role_arns) > 0 ? [1] : []

    content {
      sid    = "AllowKeyUsage"
      effect = "Allow"

      actions = [
        "kms:Decrypt",
        "kms:Encrypt",
        "kms:GenerateDataKey",
        "kms:GenerateDataKeyWithoutPlaintext",
        "kms:ReEncryptFrom",
        "kms:ReEncryptTo",
        "kms:DescribeKey"
      ]

      principals {
        type        = "AWS"
        identifiers = var.key_user_role_arns
      }

      resources = [
        "*"
      ]

      dynamic "condition" {
        for_each = length(var.allowed_via_services) > 0 ? [1] : []

        content {
          test     = "StringEquals"
          variable = "kms:ViaService"
          values   = var.allowed_via_services
        }
      }
    }
  }
}