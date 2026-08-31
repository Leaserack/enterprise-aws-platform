# ============================================================
# VPC
# ============================================================

module "vpc" {
  source = "../../modules/vpc"

  name_prefix = var.name_prefix
  environment = var.environment

  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  enable_nat_gateway       = true
  single_nat_gateway       = true
  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true

  enable_dns_support   = true
  enable_dns_hostnames = true
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

  purpose = "eks"

  description = "Customer-managed KMS key for DEV EKS encryption."

  tags = local.common_tags
}

# ============================================================
# ECR
#
# This can exist now even though no application is deployed.
# ============================================================

module "ecr" {
  source = "../../modules/ecr"

  name_prefix  = var.name_prefix
  project_name = var.project_name
  environment  = var.environment

  repository_name = "app"

  kms_key_arn = module.kms.key_arn

  image_tag_mutability = "IMMUTABLE"
  scan_on_push         = true

  force_delete = false

  untagged_image_expiration_days = 7
  tagged_image_retention_count   = 30

  tags = local.common_tags

  depends_on = [
    module.kms
  ]
}

# ============================================================
# S3
# ============================================================

module "s3" {
  source = "../../modules/s3"

  name_prefix  = var.name_prefix
  project_name = var.project_name
  environment  = var.environment

  bucket_purpose = "appdata"

  kms_key_arn = module.kms.key_arn

  enable_versioning = true

  object_lock_enabled = false
  object_lock_mode    = "GOVERNANCE"
  object_lock_days    = 30

  noncurrent_version_expiration_days = 90

  abort_incomplete_multipart_upload_days = 7

  prevent_destroy = false

  tags = local.common_tags

  depends_on = [
    module.kms
  ]
}

# ============================================================
# EKS CLUSTER
# ============================================================

module "eks" {
  source = "../../modules/eks"

  project_name = var.project_name
  environment  = var.environment

  cluster_name       = var.eks_cluster_name
  kubernetes_version = var.eks_kubernetes_version

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  cluster_role_arn = module.iam.eks_cluster_role_arn
  node_role_arn    = module.iam.eks_node_role_arn

  access_entries = {
    nodes = {
      principal_arn     = module.iam.eks_node_role_arn
      type              = "EC2_LINUX"
      kubernetes_groups = ["system:nodes"]
      username          = "system:node:{{EC2PrivateDNSName}}"
    }
  }


  cluster_encryption_key_arn = module.kms.key_arn

  # ==========================================================
  # PRIVATE EKS API
  # ==========================================================

  endpoint_private_access = true
  endpoint_public_access  = false

  # ==========================================================
  # EKS AUTHENTICATION
  # ==========================================================

  authentication_mode = "API"

  # ==========================================================
  # CONTROL PLANE LOGGING
  # ==========================================================

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
# EKS MANAGED ADD-ONS
#
# IMPORTANT:
#
# These are created BEFORE the node group.
#
# The EKS cluster itself also installs the default networking
# components during creation because bootstrap_self_managed_addons
# is TRUE in the EKS module.
#
# Terraform then manages the add-ons through the EKS API.
# ============================================================

module "eks_addons" {
  source = "../../modules/eks-addons"

  project_name = var.project_name
  environment  = var.environment

  cluster_name    = module.eks.cluster_name
  cluster_version = var.eks_kubernetes_version

  # Let EKS select the compatible versions.
  vpc_cni_version    = null
  coredns_version    = null
  kube_proxy_version = null

  # Do not enable EBS CSI yet.
  # There is no application/workload requirement for it.
  enable_ebs_csi  = false
  ebs_csi_version = null

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  service_account_role_arns = {}

  tags = local.common_tags

  depends_on = [
    module.eks
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

  # ==========================================================
  # NODE CONFIGURATION
  # ==========================================================

  ami_type       = "AL2023_x86_64_STANDARD"
  capacity_type  = "ON_DEMAND"
  instance_types = ["m7i.large"]

  disk_size = 50

  # ==========================================================
  # SCALING
  # ==========================================================

  min_size     = 3
  desired_size = 3
  max_size     = 6

  # ==========================================================
  # ROLLING UPDATE
  # ==========================================================

  update_max_unavailable = 1

  # ==========================================================
  # NODE LABELS
  # ==========================================================

  labels = {
    "platform.lr-saas.io/node-group" = "system"
    "platform.lr-saas.io/workload"   = "system"
  }

  tags = local.common_tags

  # ==========================================================
  # CRITICAL DEPENDENCIES
  #
  # 1. VPC must exist.
  # 2. IAM node role must exist.
  # 3. EKS cluster must exist.
  # 4. Networking add-ons must exist.
  #
  # No application is required.
  # ==========================================================

  depends_on = [
    module.vpc,
    module.iam,
    module.eks,
    module.eks_addons
  ]
}