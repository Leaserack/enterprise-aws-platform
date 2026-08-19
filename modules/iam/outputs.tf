output "ec2_role_name" {
  description = "Name of the EC2 workload IAM role."
  value       = try(aws_iam_role.ec2[0].name, null)
}

output "ec2_role_arn" {
  description = "ARN of the EC2 workload IAM role."
  value       = try(aws_iam_role.ec2[0].arn, null)
}

output "ec2_instance_profile_name" {
  description = "Name of the EC2 instance profile."
  value       = try(aws_iam_instance_profile.ec2[0].name, null)
}

output "ec2_instance_profile_arn" {
  description = "ARN of the EC2 instance profile."
  value       = try(aws_iam_instance_profile.ec2[0].arn, null)
}

output "eks_node_role_name" {
  description = "Name of the EKS managed node group IAM role."
  value       = try(aws_iam_role.eks_node[0].name, null)
}

output "eks_node_role_arn" {
  description = "ARN of the EKS managed node group IAM role."
  value       = try(aws_iam_role.eks_node[0].arn, null)
}