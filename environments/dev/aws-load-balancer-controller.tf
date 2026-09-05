module "aws_load_balancer_controller" {
  source = "../../modules/aws-load-balancer-controller"

  cluster_name = module.eks.cluster_name

  namespace = "kube-system"

  service_account_name = "aws-load-balancer-controller"
}
