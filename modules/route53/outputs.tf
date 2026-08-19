output "zone_id" {
  description = "Route 53 hosted zone ID."
  value       = try(aws_route53_zone.this[0].zone_id, null)
}

output "zone_arn" {
  description = "Route 53 hosted zone ARN."
  value       = try(aws_route53_zone.this[0].arn, null)
}

output "name_servers" {
  description = "Authoritative Route 53 name servers."
  value       = try(aws_route53_zone.this[0].name_servers, [])
}

output "zone_name" {
  description = "Route 53 hosted zone name."
  value       = try(aws_route53_zone.this[0].name, null)
}

output "region" {
  description = "AWS Region used by the provider."
  value       = data.aws_region.current.region
}