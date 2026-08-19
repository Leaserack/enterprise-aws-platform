# IAM Module

Reusable AWS IAM module for the LR SaaS platform.

## Purpose

This module creates workload IAM roles using least-privilege principles.

## Supported resources

- EC2 workload IAM role
- EC2 instance profile
- EKS managed node group IAM role
- EKS worker node policy
- EKS CNI policy
- ECR pull-only policy

## Important

The GitHub Actions OIDC deployment role is managed separately as platform bootstrap infrastructure.

This module does not manage:

- GitHubActionsTerraformRole
- GitHub OIDC provider
- Organization-level IAM
- Root account configuration

## Naming

Resources use the following pattern:

lr-saas-<environment>-<resource>

Examples:

lr-saas-dev-ec2-role
lr-saas-dev-eks-node-role

## Versioning

The module is consumed using Git tags.

Example:

```hcl
module "iam" {
  source = "git::https://github.com/Leaserack/enterprise-aws-platform.git//modules/iam?ref=iam-v1.0.0"
}