aws_region = "us-east-1"

project_name = "lr-saas"

environment = "dev"

name_prefix = "lr-saas"

vpc_cidr = "10.10.0.0/16"

availability_zones = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c"
]

eks_cluster_name       = "lr-saas-dev-eks"
eks_kubernetes_version = "1.33"