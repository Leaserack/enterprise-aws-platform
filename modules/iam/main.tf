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

  ec2_role_name         = "${var.name_prefix}-${var.environment}-ec2-role"
  eks_node_role_name    = "${var.name_prefix}-${var.environment}-eks-node-role"
  eks_cluster_role_name = "${var.name_prefix}-${var.environment}-eks-cluster-role"
}

# ============================================================
# EC2 WORKLOAD ROLE
# ============================================================

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    sid     = "EC2AssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2" {
  count = var.create_ec2_role ? 1 : 0

  name               = local.ec2_role_name
  description        = "EC2 workload role for ${var.name_prefix}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = local.common_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "ec2" {
  count = var.create_ec2_role ? 1 : 0

  name = "${local.ec2_role_name}-profile"
  role = aws_iam_role.ec2[0].name

  tags = local.common_tags
}

# ============================================================
# EKS CONTROL PLANE ROLE
# ============================================================

data "aws_iam_policy_document" "eks_cluster_assume_role" {
  statement {
    sid     = "EKSClusterAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_cluster" {
  count = var.create_eks_cluster_role ? 1 : 0

  name               = local.eks_cluster_role_name
  description        = "EKS control plane role for ${var.name_prefix}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json

  tags = local.common_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  count = var.create_eks_cluster_role ? 1 : 0

  role       = aws_iam_role.eks_cluster[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# ============================================================
# EKS MANAGED NODE GROUP ROLE
# ============================================================

data "aws_iam_policy_document" "eks_node_assume_role" {
  statement {
    sid     = "EKSNodeAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_node" {
  count = var.create_eks_node_role ? 1 : 0

  name               = local.eks_node_role_name
  description        = "EKS managed node group role for ${var.name_prefix}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role.json

  tags = local.common_tags

  lifecycle {
    create_before_destroy = true
  }
}

# ============================================================
# EKS WORKER NODE POLICY
# ============================================================

resource "aws_iam_role_policy_attachment" "eks_worker_node" {
  count = var.create_eks_node_role ? 1 : 0

  role       = aws_iam_role.eks_node[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# ============================================================
# EKS VPC CNI POLICY
# ============================================================

resource "aws_iam_role_policy_attachment" "eks_cni" {
  count = var.create_eks_node_role ? 1 : 0

  role       = aws_iam_role.eks_node[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# ============================================================
# ECR PULL POLICY
# ============================================================

resource "aws_iam_role_policy_attachment" "ecr_pull" {
  count = var.create_eks_node_role ? 1 : 0

  role       = aws_iam_role.eks_node[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}