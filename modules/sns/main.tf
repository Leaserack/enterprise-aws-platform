resource "aws_sns_topic" "this" {
  name = var.fifo_topic ? "${local.topic_name}.fifo" : local.topic_name

  display_name = var.display_name

  fifo_topic                  = var.fifo_topic
  content_based_deduplication = var.fifo_topic ? var.content_based_deduplication : false

  kms_master_key_id = var.kms_key_arn

  tags = merge(
    local.common_tags,
    {
      Name = local.topic_name
    }
  )
}

resource "aws_sns_topic_subscription" "this" {
  for_each = var.subscriptions

  topic_arn = aws_sns_topic.this.arn
  protocol  = each.value.protocol
  endpoint  = each.value.endpoint
}