data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "this" {
  name        = coalesce(var.iam_policy_name, "${var.cluster_name}-AWSLoadBalancerController")
  description = "IAM permissions for AWS Load Balancer Controller on ${var.cluster_name}"

  policy = file("${path.module}/iam-policy.json")

  tags = {
    Name      = "${var.cluster_name}-AWSLoadBalancerController"
    ManagedBy = "Terraform"
    Component = "aws-load-balancer-controller"
  }
}

resource "aws_iam_role" "this" {
  name = coalesce(
    var.iam_role_name,
    "${var.cluster_name}-aws-load-balancer-controller"
  )

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "pods.eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = {
    Name      = "${var.cluster_name}-aws-load-balancer-controller"
    ManagedBy = "Terraform"
    Component = "aws-load-balancer-controller"
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_eks_pod_identity_association" "this" {
  cluster_name    = var.cluster_name
  namespace       = var.namespace
  service_account = var.service_account_name
  role_arn        = aws_iam_role.this.arn

  depends_on = [
    aws_iam_role_policy_attachment.this
  ]
}
