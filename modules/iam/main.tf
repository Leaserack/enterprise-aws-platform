locals {
  common_tags = merge(
    {
      ManagedBy   = "Terraform"
      Environment = var.environment
      Component   = "iam"
      NamePrefix  = var.name_prefix
    },
    var.tags
  )

  ec2_role_name      = "${var.name_prefix}-${var.environment}-ec2-role"
  eks_node_role_name = "${var.name_prefix}-${var.environment}-eks-node-role"
}

# ------------------------------------------------------------
# EC2 workload role
# ------------------------------------------------------------

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    sid    = "EC2AssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "ec2" {
  count = var.create_ec2_role ? 1 : 0

  name = local.ec2_role_name

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  description = "EC2 workload role for ${var.name_prefix}-${var.environment}"

  tags = local.common_tags
}

resource "aws_iam_instance_profile" "ec2" {
  count = var.create_ec2_role ? 1 : 0

  name = "${local.ec2_role_name}-profile"

  role = aws_iam_role.ec2[0].name

  tags = local.common_tags
}

# ------------------------------------------------------------
# EKS managed node group role
# ------------------------------------------------------------

data "aws_iam_policy_document" "eks_node_assume_role" {
  statement {
    sid    = "EKSNodeAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "eks_node" {
  count = var.create_eks_node_role ? 1 : 0

  name = local.eks_node_role_name

  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role.json

  description = "EKS managed node group role for ${var.name_prefix}-${var.environment}"

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "eks_worker_node" {
  count = var.create_eks_node_role ? 1 : 0

  role = aws_iam_role.eks_node[0].name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni" {
  count = var.create_eks_node_role ? 1 : 0

  role = aws_iam_role.eks_node[0].name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_pull" {
  count = var.create_eks_node_role ? 1 : 0

  role = aws_iam_role.eks_node[0].name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}