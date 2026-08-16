output "vpc_id" {
  description = "DEV VPC ID."
  value       = module.vpc.vpc_id
}

output "vpc_name" {
  description = "DEV VPC name."
  value       = module.vpc.vpc_name
}

output "vpc_cidr" {
  description = "DEV VPC CIDR."
  value       = module.vpc.vpc_cidr
}

output "internet_gateway_id" {
  description = "DEV Internet Gateway ID."
  value       = module.vpc.internet_gateway_id
}

output "public_subnet_ids" {
  description = "DEV public subnet IDs."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "DEV private subnet IDs."
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_ids" {
  description = "DEV NAT Gateway IDs."
  value       = module.vpc.nat_gateway_ids
}