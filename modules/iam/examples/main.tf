terraform {
  required_version = ">= 1.15.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.57.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "iam" {
  source = "../../"

  name_prefix = "lr-saas"
  environment = "dev"

  create_ec2_role      = true
  create_eks_node_role = true

  tags = {
    Project = "lr-saas"
    Owner   = "platform"
  }
}