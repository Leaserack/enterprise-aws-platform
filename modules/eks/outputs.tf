output "cluster_id" {
  description = "EKS cluster ID."
  value       = aws_eks_cluster.this.id
}

output "cluster_name" {
  description = "EKS cluster name."
  value       = aws_eks_cluster.this.name
}

output "cluster_arn" {
  description = "EKS cluster ARN."
  value       = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  description = "EKS Kubernetes API endpoint."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_version" {
  description = "EKS Kubernetes version."
  value       = aws_eks_cluster.this.version
}

output "cluster_platform_version" {
  description = "EKS platform version."
  value       = aws_eks_cluster.this.platform_version
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded EKS cluster CA."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_security_group_id" {
  description = "EKS cluster security group ID."
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "cluster_primary_security_group_id" {
  description = "Primary EKS cluster security group ID."
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "cluster_oidc_issuer_url" {
  description = "EKS OIDC issuer URL. Kept for IRSA-compatible workloads."
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "cluster_encryption_key_arn" {
  description = "KMS key ARN used for EKS secret encryption."
  value       = var.cluster_encryption_key_arn
}

output "access_entries" {
  description = "EKS access entries."
  value = {
    for name, entry in aws_eks_access_entry.this :
    name => {
      principal_arn     = entry.principal_arn
      type              = entry.type
      kubernetes_groups = entry.kubernetes_groups
    }
  }
}

output "access_policy_associations" {
  description = "EKS access policy associations."
  value = {
    for name, association in aws_eks_access_policy_association.this :
    name => {
      principal_arn = association.principal_arn
      policy_arn    = association.policy_arn
    }
  }
}

output "region" {
  description = "AWS Region where the cluster is deployed."
  value       = data.aws_region.current.region
}