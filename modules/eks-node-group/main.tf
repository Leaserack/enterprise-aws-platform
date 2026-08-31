# ============================================================
# EKS MANAGED NODE GROUP
# ============================================================

resource "aws_eks_node_group" "this" {
  cluster_name = var.cluster_name

  node_group_name = local.node_group_name

  node_role_arn = var.node_role_arn

  subnet_ids = var.subnet_ids

  # ----------------------------------------------------------
  # Node configuration
  # ----------------------------------------------------------

  ami_type       = var.ami_type
  capacity_type  = var.capacity_type
  instance_types = var.instance_types

  disk_size = var.disk_size

  # ----------------------------------------------------------
  # Scaling
  # ----------------------------------------------------------

  scaling_config {
    min_size     = var.min_size
    desired_size = var.desired_size
    max_size     = var.max_size
  }

  # ----------------------------------------------------------
  # Rolling update
  # ----------------------------------------------------------

  update_config {
    max_unavailable = var.update_max_unavailable
  }

  # ----------------------------------------------------------
  # Kubernetes labels
  # ----------------------------------------------------------

  labels = var.labels

  # ----------------------------------------------------------
  # Tags
  # ----------------------------------------------------------

  tags = local.common_tags

  lifecycle {
    create_before_destroy = true
  }
}