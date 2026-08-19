output "eks_cluster_security_group_id" {
  description = "EKS cluster security group ID."
  value       = try(aws_security_group.eks_cluster[0].id, null)
}

output "eks_node_security_group_id" {
  description = "EKS node security group ID."
  value       = try(aws_security_group.eks_node[0].id, null)
}

output "alb_security_group_id" {
  description = "Application Load Balancer security group ID."
  value       = try(aws_security_group.alb[0].id, null)
}

output "application_security_group_id" {
  description = "Application security group ID."
  value       = try(aws_security_group.application[0].id, null)
}

output "database_security_group_id" {
  description = "Database security group ID."
  value       = try(aws_security_group.database[0].id, null)
}

output "pod_security_group_id" {
  description = "Security group intended for sensitive EKS pods."
  value       = try(aws_security_group.pod[0].id, null)
}