output "node_group_name" {
  description = "EKS managed node group name."
  value       = aws_eks_node_group.this.node_group_name
}

output "node_group_arn" {
  description = "EKS managed node group ARN."
  value       = aws_eks_node_group.this.arn
}

output "node_group_status" {
  description = "EKS managed node group status."
  value       = aws_eks_node_group.this.status
}

output "node_role_arn" {
  description = "IAM role ARN used by the node group."
  value       = aws_eks_node_group.this.node_role_arn
}

output "resources" {
  description = "Underlying node group resources."
  value       = aws_eks_node_group.this.resources
}