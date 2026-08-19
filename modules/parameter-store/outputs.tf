output "parameter_name" {
  description = "SSM parameter name."
  value       = aws_ssm_parameter.this.name
}

output "parameter_arn" {
  description = "SSM parameter ARN."
  value       = aws_ssm_parameter.this.arn
}

output "parameter_type" {
  description = "SSM parameter type."
  value       = aws_ssm_parameter.this.type
}

output "parameter_version" {
  description = "Current SSM parameter version."
  value       = aws_ssm_parameter.this.version
}

output "region" {
  description = "AWS Region containing the parameter."
  value       = data.aws_region.current.region
}