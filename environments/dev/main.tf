# ============================================================
# VPC
# ============================================================

module "vpc" {
  source = "../../modules/vpc"

  name_prefix = var.name_prefix
  environment = var.environment

  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones

  tags = local.common_tags
}

# ============================================================
# IAM
# ============================================================

module "iam" {
  source = "../../modules/iam"

  name_prefix = var.name_prefix
  environment = var.environment

  create_ec2_role         = true
  create_eks_node_role    = true
  create_eks_cluster_role = true

  tags = local.common_tags
}

# ============================================================
# KMS
# ============================================================

module "kms" {
  source = "../../modules/kms"

  name_prefix = var.name_prefix
  environment = var.environment

  tags = local.common_tags
}

# ============================================================
# ECR
# ============================================================

module "ecr" {
  source = "../../modules/ecr"

  name_prefix = var.name_prefix
  environment = var.environment

  tags = local.common_tags
}

# ============================================================
# S3
# ============================================================

module "s3" {
  source = "../../modules/s3"

  name_prefix = var.name_prefix
  environment = var.environment

  tags = local.common_tags
}

# ============================================================
# EKS CLUSTER
# ============================================================

module "eks" {
  source = "../../modules/eks"

  project_name = var.project_name
  environment = var.environment

  cluster_name       = var.eks_cluster_name
  kubernetes_version = var.eks_kubernetes_version

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  cluster_role_arn = module.iam.eks_cluster_role_arn
  node_role_arn    = module.iam.eks_node_role_arn

  cluster_encryption_key_arn = module.kms.key_arn

  # ----------------------------------------------------------
  # Private EKS API
  # ----------------------------------------------------------

  endpoint_private_access = true
  endpoint_public_access  = false

  # ----------------------------------------------------------
  # EKS authentication
  # ----------------------------------------------------------

  authentication_mode = "API"

  # ----------------------------------------------------------
  # Control-plane logging
  # ----------------------------------------------------------

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  tags = local.common_tags

  depends_on = [
    module.vpc,
    module.iam,
    module.kms
  ]
}

# ============================================================
# EKS SYSTEM NODE GROUP
# ============================================================

module "eks_node_group" {
  source = "../../modules/eks-node-group"

  name_prefix  = var.name_prefix
  project_name = var.project_name
  environment  = var.environment

  cluster_name = module.eks.cluster_name

  node_group_name = "${var.name_prefix}-${var.environment}-system"

  node_role_arn = module.iam.eks_node_role_arn

  subnet_ids = module.vpc.private_subnet_ids

  # ----------------------------------------------------------
  # Node configuration
  # ----------------------------------------------------------

  ami_type       = "AL2023_x86_64_STANDARD"
  capacity_type  = "ON_DEMAND"
  instance_types = ["m7i.large"]

  disk_size = 50

  # ----------------------------------------------------------
  # Scaling
  # ----------------------------------------------------------

  min_size     = 3
  desired_size = 3
  max_size     = 6

  # ----------------------------------------------------------
  # Rolling update
  # ----------------------------------------------------------

  update_max_unavailable = 1

  # ----------------------------------------------------------
  # System node labels
  # ----------------------------------------------------------

  labels = {
    "platform.lr-saas.io/node-group" = "system"
    "platform.lr-saas.io/workload"   = "system"
  }

  tags = local.common_tags

  depends_on = [
    module.eks
  ]
}

# ============================================================
# EKS MANAGED ADD-ONS
# ============================================================

module "eks_addons" {
  source = "../../modules/eks-addons"

  project_name = var.project_name
  environment  = var.environment

  cluster_name = module.eks.cluster_name
  cluster_version = var.eks_kubernetes_version

  # ----------------------------------------------------------
  # Add-on versions
  #
  # null = AWS-compatible default for the cluster version.
  # We will pin tested versions after initial deployment.
  # ----------------------------------------------------------

  vpc_cni_version    = null
  coredns_version    = null
  kube_proxy_version = null
  ebs_csi_version    = null

  # ----------------------------------------------------------
  # Conflict handling
  # ----------------------------------------------------------

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  # ----------------------------------------------------------
  # Workload identity
  #
  # Pod Identity / dedicated add-on roles will be hardened
  # in the next platform phase.
  # ----------------------------------------------------------

  service_account_role_arns = {}

  tags = local.common_tags

  depends_on = [
    module.eks,
    module.eks_node_group
  ]
}