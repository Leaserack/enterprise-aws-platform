data "aws_iam_policy_document" "ebs_csi_pod_identity_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "pods.eks.amazonaws.com"
      ]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "ebs_csi" {
  count = var.enable_ebs_csi ? 1 : 0

  name = "${var.project_name}-${var.environment}-eks-ebs-csi-role"

  assume_role_policy = data.aws_iam_policy_document.ebs_csi_pod_identity_assume_role.json

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-eks-ebs-csi-role"
    }
  )
}

resource "aws_iam_role_policy_attachment" "ebs_csi" {
  count = var.enable_ebs_csi ? 1 : 0

  role = aws_iam_role.ebs_csi[0].name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEBSCSIDriverPolicyV2"
}

resource "aws_eks_pod_identity_association" "ebs_csi" {
  count = var.enable_ebs_csi ? 1 : 0

  cluster_name = var.cluster_name

  namespace = "kube-system"

  service_account = "ebs-csi-controller-sa"

  role_arn = aws_iam_role.ebs_csi[0].arn

  depends_on = [
    aws_eks_addon.pod_identity_agent,
    aws_eks_addon.ebs_csi,
    aws_iam_role_policy_attachment.ebs_csi
  ]

}