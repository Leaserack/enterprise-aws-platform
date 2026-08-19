output "vpc_cni_addon_arn" {
  description = "VPC CNI add-on ARN."
  value       = aws_eks_addon.vpc_cni.arn
}

output "vpc_cni_addon_version" {
  description = "Installed VPC CNI version."
  value       = aws_eks_addon.vpc_cni.addon_version
}

output "coredns_addon_arn" {
  description = "CoreDNS add-on ARN."
  value       = aws_eks_addon.coredns.arn
}

output "coredns_addon_version" {
  description = "Installed CoreDNS version."
  value       = aws_eks_addon.coredns.addon_version
}

output "kube_proxy_addon_arn" {
  description = "kube-proxy add-on ARN."
  value       = aws_eks_addon.kube_proxy.arn
}

output "kube_proxy_addon_version" {
  description = "Installed kube-proxy version."
  value       = aws_eks_addon.kube_proxy.addon_version
}

output "ebs_csi_addon_arn" {
  description = "EBS CSI Driver add-on ARN."
  value       = aws_eks_addon.ebs_csi.arn
}

output "ebs_csi_addon_version" {
  description = "Installed EBS CSI Driver version."
  value       = aws_eks_addon.ebs_csi.addon_version
}