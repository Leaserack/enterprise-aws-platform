output "security_group_id" {
  description = "ALB security group ID."
  value       = local.alb_security_group_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs available for internet-facing ALBs."
  value       = var.public_subnet_ids
}

output "internal_subnet_ids" {
  description = "Private subnet IDs available for internal ALBs."
  value       = var.internal_subnet_ids
}

output "region" {
  description = "AWS Region."
  value       = data.aws_region.current.region
}