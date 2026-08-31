locals {
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Component   = "eks-addons"
      Cluster     = var.cluster_name
    },
    var.tags
  )
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = var.cluster_name
  addon_name   = "vpc-cni"

  addon_version = var.vpc_cni_version

  resolve_conflicts_on_create = var.resolve_conflicts_on_create
  resolve_conflicts_on_update = var.resolve_conflicts_on_update

  service_account_role_arn = lookup(
    var.service_account_role_arns,
    "vpc-cni",
    null
  )

  tags = local.common_tags
}

resource "aws_eks_addon" "coredns" {
  cluster_name = var.cluster_name
  addon_name   = "coredns"

  addon_version = var.coredns_version

  resolve_conflicts_on_create = var.resolve_conflicts_on_create
  resolve_conflicts_on_update = var.resolve_conflicts_on_update

  service_account_role_arn = lookup(
    var.service_account_role_arns,
    "coredns",
    null
  )

  tags = local.common_tags
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = var.cluster_name
  addon_name   = "kube-proxy"

  addon_version = var.kube_proxy_version

  resolve_conflicts_on_create = var.resolve_conflicts_on_create
  resolve_conflicts_on_update = var.resolve_conflicts_on_update

  service_account_role_arn = lookup(
    var.service_account_role_arns,
    "kube-proxy",
    null
  )

  tags = local.common_tags
}

resource "aws_eks_addon" "ebs_csi" {
  count = var.enable_ebs_csi ? 1 : 0

  cluster_name = var.cluster_name
  addon_name   = "aws-ebs-csi-driver"

  addon_version = var.ebs_csi_version

  resolve_conflicts_on_create = var.resolve_conflicts_on_create
  resolve_conflicts_on_update = var.resolve_conflicts_on_update

  service_account_role_arn = lookup(
    var.service_account_role_arns,
    "aws-ebs-csi-driver",
    null
  )

  tags = local.common_tags
}