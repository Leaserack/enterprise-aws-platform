# Security Groups Module

Reusable AWS Security Groups module for the LR SaaS platform.

## Purpose

Provides security-group boundaries for:

- Amazon EKS control plane
- EKS worker nodes
- Application Load Balancer
- Application workloads
- Database workloads
- Sensitive EKS pods

## Naming

Resources follow:

lr-saas-<environment>-<component>

Examples:

lr-saas-dev-eks-cluster-sg
lr-saas-dev-eks-node-sg
lr-saas-dev-alb-sg
lr-saas-dev-app-sg
lr-saas-dev-db-sg
lr-saas-dev-pod-sg

## Security model

This module provides AWS VPC-level network controls.

It does not replace Kubernetes NetworkPolicy.

The target EKS architecture uses layered controls:

1. AWS Security Groups
2. Security Groups for Pods where required
3. Kubernetes NetworkPolicy
4. Kubernetes RBAC
5. EKS Pod Identity
6. IAM least privilege
7. WAF
8. Encryption
9. Logging and monitoring

## EKS integration

The following security groups are intended for later EKS integration:

- EKS cluster SG
- EKS node SG
- ALB SG
- Application SG
- Database SG
- Sensitive pod SG

## Workload identity

Application IAM permissions will be implemented separately using EKS Pod Identity as the primary approach.

IRSA will remain available where compatibility requirements justify its use.

## Security principles

- Least privilege
- Explicit ingress
- Explicit egress where appropriate
- No unrestricted database access
- No direct internet access to workloads
- No SSH/RDP ingress by default
- No hard-coded AWS account IDs
- No hard-coded AWS regions
- Deterministic naming
- Mandatory tagging

## Versioning

This module is consumed using immutable Git tags.

Example:

```hcl
module "security_groups" {
  source = "git::https://github.com/Leaserack/enterprise-aws-platform.git//modules/security-groups?ref=sg-v1.0.0"
}