resource "aws_eks_cluster" "this" {
  name     = local.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  bootstrap_self_managed_addons = false

  access_config {
    authentication_mode = var.authentication_mode
  }

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = var.cluster_security_group_id != null ? [var.cluster_security_group_id] : null
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.endpoint_public_access ? var.public_access_cidrs : []
  }

  enabled_cluster_log_types = var.enabled_cluster_log_types

  encryption_config {
    provider {
      key_arn = var.cluster_encryption_key_arn
    }

    resources = [
      "secrets"
    ]
  }

  tags = local.common_tags

  lifecycle {
    precondition {
      condition = (
        var.endpoint_private_access ||
        var.endpoint_public_access
      )

      error_message = "At least one EKS API endpoint access mode must be enabled."
    }

    precondition {
      condition = (
        !var.endpoint_public_access ||
        length(var.public_access_cidrs) > 0
      )

      error_message = "public_access_cidrs must contain at least one CIDR when public EKS API access is enabled."
    }
  }
}