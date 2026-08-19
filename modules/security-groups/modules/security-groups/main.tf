# ------------------------------------------------------------
# EKS Cluster Security Group
# ------------------------------------------------------------

resource "aws_security_group" "eks_cluster" {
  count = var.create_cluster_sg ? 1 : 0

  name        = local.cluster_sg_name
  description = "EKS cluster control-plane security group for ${local.resource_prefix}"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = local.cluster_sg_name
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------
# EKS Node Security Group
# ------------------------------------------------------------

resource "aws_security_group" "eks_node" {
  count = var.create_node_sg ? 1 : 0

  name        = local.node_sg_name
  description = "EKS worker node security group for ${local.resource_prefix}"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = local.node_sg_name
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------
# ALB Security Group
# ------------------------------------------------------------

resource "aws_security_group" "alb" {
  count = var.create_alb_sg ? 1 : 0

  name        = local.alb_sg_name
  description = "Application Load Balancer security group for ${local.resource_prefix}"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = local.alb_sg_name
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------
# Application Security Group
# ------------------------------------------------------------

resource "aws_security_group" "application" {
  count = var.create_app_sg ? 1 : 0

  name        = local.app_sg_name
  description = "Application workload security group for ${local.resource_prefix}"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = local.app_sg_name
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------
# Database Security Group
# ------------------------------------------------------------

resource "aws_security_group" "database" {
  count = var.create_database_sg ? 1 : 0

  name        = local.db_sg_name
  description = "Database security group for ${local.resource_prefix}"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = local.db_sg_name
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------
# Sensitive Pod Security Group
# ------------------------------------------------------------

resource "aws_security_group" "pod" {
  count = var.create_pod_sg ? 1 : 0

  name        = local.pod_sg_name
  description = "Security group for sensitive EKS pods for ${local.resource_prefix}"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = local.pod_sg_name
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# ============================================================
# ALB INGRESS
# ============================================================

resource "aws_vpc_security_group_ingress_rule" "alb" {
  for_each = var.create_alb_sg ? {
    for item in flatten([
      for port in var.alb_ingress_ports : [
        for cidr in var.allowed_ingress_cidr_blocks : {
          key  = "${port}-${cidr}"
          port = port
          cidr = cidr
        }
      ]
    ]) : item.key => item
  } : {}

  security_group_id = aws_security_group.alb[0].id

  cidr_ipv4   = each.value.cidr
  from_port   = each.value.port
  to_port     = each.value.port
  ip_protocol = "tcp"

  description = "Approved HTTPS ingress"
}

# ============================================================
# ALB EGRESS
# ============================================================

resource "aws_vpc_security_group_egress_rule" "alb" {
  count = var.create_alb_sg ? 1 : 0

  security_group_id = aws_security_group.alb[0].id

  referenced_security_group_id = var.create_app_sg ? aws_security_group.application[0].id : null

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 65535

  description = "ALB to application workloads"
}

# ============================================================
# NODE → CLUSTER
# ============================================================

resource "aws_vpc_security_group_ingress_rule" "cluster_from_nodes" {
  count = var.create_cluster_sg && var.create_node_sg ? 1 : 0

  security_group_id = aws_security_group.eks_cluster[0].id

  referenced_security_group_id = aws_security_group.eks_node[0].id

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443

  description = "EKS nodes to Kubernetes API"
}

# ============================================================
# CLUSTER → NODE
# ============================================================

resource "aws_vpc_security_group_ingress_rule" "nodes_from_cluster" {
  count = var.create_cluster_sg && var.create_node_sg ? 1 : 0

  security_group_id = aws_security_group.eks_node[0].id

  referenced_security_group_id = aws_security_group.eks_cluster[0].id

  ip_protocol = "tcp"
  from_port   = 10250
  to_port     = 10250

  description = "EKS control plane to kubelet"
}

# ============================================================
# NODE → NODE
# ============================================================

resource "aws_vpc_security_group_ingress_rule" "nodes_from_nodes" {
  count = var.create_node_sg ? 1 : 0

  security_group_id = aws_security_group.eks_node[0].id

  referenced_security_group_id = aws_security_group.eks_node[0].id

  ip_protocol = "-1"

  description = "Required node-to-node communication"
}

# ============================================================
# APPLICATION ← ALB
# ============================================================

resource "aws_vpc_security_group_ingress_rule" "application_from_alb" {
  count = var.create_app_sg && var.create_alb_sg ? 1 : 0

  security_group_id = aws_security_group.application[0].id

  referenced_security_group_id = aws_security_group.alb[0].id

  ip_protocol = "tcp"
  from_port   = 8080
  to_port     = 8080

  description = "Application traffic from ALB"
}

# ============================================================
# DATABASE ← APPLICATION
# ============================================================

resource "aws_vpc_security_group_ingress_rule" "database_from_application" {
  count = var.create_database_sg && var.create_app_sg ? 1 : 0

  security_group_id = aws_security_group.database[0].id

  referenced_security_group_id = aws_security_group.application[0].id

  ip_protocol = "tcp"
  from_port   = 5432
  to_port     = 5432

  description = "PostgreSQL traffic from application workloads"
}