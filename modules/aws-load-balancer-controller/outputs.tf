output "iam_role_arn" {
  description = "IAM role ARN used by AWS Load Balancer Controller"
  value       = aws_iam_role.this.arn
}

output "iam_policy_arn" {
  description = "IAM policy ARN used by AWS Load Balancer Controller"
  value       = aws_iam_policy.this.arn
}

output "pod_identity_association_id" {
  description = "EKS Pod Identity association ID"
  value       = aws_eks_pod_identity_association.this.association_id
}
