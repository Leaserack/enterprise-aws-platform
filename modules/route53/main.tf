resource "aws_route53_zone" "this" {
  count = var.create_zone ? 1 : 0

  name    = var.domain_name
  comment = "${var.project_name}-${var.environment} DNS hosted zone"

  dynamic "vpc" {
    for_each = var.private_zone && var.vpc_id != null ? [1] : []

    content {
      vpc_id = var.vpc_id
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-zone"
    }
  )
}

resource "aws_route53_record" "this" {
  for_each = var.create_zone ? var.records : {}

  zone_id = aws_route53_zone.this[0].zone_id
  name    = each.key
  type    = each.value.type

  ttl = each.value.alias_name == null ? each.value.ttl : null

  records = each.value.alias_name == null ? each.value.records : null

  dynamic "alias" {
    for_each = each.value.alias_name != null ? [1] : []

    content {
      name                   = each.value.alias_name
      zone_id                = each.value.alias_zone_id
      evaluate_target_health = each.value.evaluate_target
    }
  }
}