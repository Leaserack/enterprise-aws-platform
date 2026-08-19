output "secret_id" {
  description = "Secrets Manager secret ID."
  value       = aws_secretsmanager_secret.this.id
}

output "secret_arn" {
  description = "Secrets Manager secret ARN."
  value       = aws_secretsmanager_secret.this.arn
}

output "secret_name" {
  description = "Secrets Manager secret name."
  value       = aws_secretsmanager_secret.this.name
}

output "secret_kms_key_id" {
  description = "KMS key ID used for secret encryption."
  value       = aws_secretsmanager_secret.this.kms_key_id
}

output "region" {
  description = "AWS Region containing the secret."
  value       = data.aws_region.current.region
}