terraform {
  required_version = ">= 1.15.8"
  required_providers {
    aws = {
      source  = "harshicorp/aws"
      version = ">= 6.57.1"
    }
  }

}