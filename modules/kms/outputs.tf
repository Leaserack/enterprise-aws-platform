output "key_id" {
  description = "KMS key ID."
  value       = aws_kms_key.this.key_id
}

output "key_arn" {
  description = "KMS key ARN."
  value       = aws_kms_key.this.arn
}

output "alias_name" {
  description = "KMS alias name."
  value       = aws_kms_alias.this.name
}

output "alias_arn" {
  description = "KMS alias ARN."
  value       = aws_kms_alias.this.arn
}

output "key_region" {
  description = "AWS Region containing the KMS key."
  value       = data.aws_region.current.region
}

output "account_id" {
  description = "AWS account ID containing the KMS key."
  value       = data.aws_caller_identity.current.account_id
}

output "multi_region" {
  description = "Whether the KMS key is multi-Region."
  value       = aws_kms_key.this.multi_region
}