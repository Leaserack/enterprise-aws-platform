output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "ARN of the VPC."
  value       = aws_vpc.this.arn
}

output "vpc_cidr" {
  description = "CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "vpc_name" {
  description = "Name of the VPC."
  value       = "${local.resource_prefix}-vpc"
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway."
  value       = aws_internet_gateway.this.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets."
  value = [
    for subnet in aws_subnet.public :
    subnet.id
  ]
}

output "private_subnet_ids" {
  description = "IDs of private subnets."
  value = [
    for subnet in aws_subnet.private :
    subnet.id
  ]
}

output "public_subnet_ids_by_key" {
  description = "Public subnet IDs keyed by subnet number."
  value = {
    for key, subnet in aws_subnet.public :
    key => subnet.id
  }
}

output "private_subnet_ids_by_key" {
  description = "Private subnet IDs keyed by subnet number."
  value = {
    for key, subnet in aws_subnet.private :
    key => subnet.id
  }
}

output "public_route_table_id" {
  description = "ID of the public route table."
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "Private route table IDs keyed by Availability Zone."
  value = {
    for az, route_table in aws_route_table.private :
    az => route_table.id
  }
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs."
  value = [
    for nat_gateway in aws_nat_gateway.this :
    nat_gateway.id
  ]
}

output "s3_vpc_endpoint_id" {
  description = "S3 Gateway VPC endpoint ID."
  value = try(
    aws_vpc_endpoint.s3[0].id,
    null
  )
}

output "dynamodb_vpc_endpoint_id" {
  description = "DynamoDB Gateway VPC endpoint ID."
  value = try(
    aws_vpc_endpoint.dynamodb[0].id,
    null
  )
}