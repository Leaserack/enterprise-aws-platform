resource "aws_security_group" "alb" {
  count = var.create_security_group ? 1 : 0

  name_prefix = "${var.project_name}-${var.environment}-alb-"
  description = "Security group for ${var.project_name} ${var.environment} ALB"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-alb-sg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  alb_security_group_id = var.create_security_group ? aws_security_group.alb[0].id : var.security_group_id
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  for_each = var.enable_https ? toset(var.allowed_ingress_cidrs) : toset([])

  security_group_id = local.alb_security_group_id
  cidr_ipv4         = each.value
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"

  description = "HTTPS access to ALB"
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  for_each = var.enable_http ? toset(var.allowed_ingress_cidrs) : toset([])

  security_group_id = local.alb_security_group_id
  cidr_ipv4         = each.value
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"

  description = "HTTP access to ALB"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = local.alb_security_group_id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  description = "Allow ALB outbound traffic"
}