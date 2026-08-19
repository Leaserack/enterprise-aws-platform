output "topic_arn" {
  description = "SNS topic ARN."
  value       = aws_sns_topic.this.arn
}

output "topic_name" {
  description = "SNS topic name."
  value       = aws_sns_topic.this.name
}

output "topic_id" {
  description = "SNS topic ID."
  value       = aws_sns_topic.this.id
}

output "region" {
  description = "AWS Region containing the SNS topic."
  value       = data.aws_region.current.region
}