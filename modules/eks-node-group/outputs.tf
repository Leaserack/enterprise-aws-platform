output "node_group_name" {
  description = "EKS managed node group name."
  value       = aws_eks_node_group.this.node_group_name
}

output "node_group_arn" {
  description = "ARN of the EKS managed node group."
  value       = aws_eks_node_group.this.arn
}

output "node_group_status" {
  description = "Current EKS managed node group status."
  value       = aws_eks_node_group.this.status
}

output "node_role_arn" {
  description = "IAM role ARN used by the node group."
  value       = aws_eks_node_group.this.node_role_arn
}

output "subnet_ids" {
  description = "Subnets used by the node group."
  value       = aws_eks_node_group.this.subnet_ids
}

output "instance_types" {
  description = "EC2 instance types used by the node group."
  value       = aws_eks_node_group.this.instance_types
}

output "capacity_type" {
  description = "Capacity type of the node group."
  value       = aws_eks_node_group.this.capacity_type
}

output "ami_type" {
  description = "AMI type used by the node group."
  value       = aws_eks_node_group.this.ami_type
}

output "desired_size" {
  description = "Desired node count."
  value       = aws_eks_node_group.this.scaling_config[0].desired_size
}

output "min_size" {
  description = "Minimum node count."
  value       = aws_eks_node_group.this.scaling_config[0].min_size
}

output "max_size" {
  description = "Maximum node count."
  value       = aws_eks_node_group.this.scaling_config[0].max_size
}