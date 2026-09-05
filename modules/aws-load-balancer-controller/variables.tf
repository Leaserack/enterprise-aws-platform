variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace where AWS Load Balancer Controller runs"
  type        = string
  default     = "kube-system"
}

variable "service_account_name" {
  description = "Kubernetes service account used by AWS Load Balancer Controller"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "iam_policy_name" {
  description = "IAM policy name for AWS Load Balancer Controller"
  type        = string
  default     = null
}

variable "iam_role_name" {
  description = "IAM role name for AWS Load Balancer Controller"
  type        = string
  default     = null
}
