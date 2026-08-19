output "certificate_arn" {
  description = "ACM certificate ARN."
  value       = aws_acm_certificate.this.arn
}

output "certificate_id" {
  description = "ACM certificate ID."
  value       = aws_acm_certificate.this.id
}

output "domain_name" {
  description = "Primary certificate domain."
  value       = aws_acm_certificate.this.domain_name
}

output "status" {
  description = "Current ACM certificate status."
  value       = aws_acm_certificate.this.status
}

output "validation_method" {
  description = "Certificate validation method."
  value       = aws_acm_certificate.this.validation_method
}

output "region" {
  description = "AWS Region containing the certificate."
  value       = data.aws_region.current.region
}