# AWS Load Balancer Controller

This Terraform module creates the AWS-side IAM prerequisites for the
AWS Load Balancer Controller running in Amazon EKS.

## Responsibilities

Terraform manages:

- IAM policy
- IAM role
- IAM policy attachment
- EKS Pod Identity association

Argo CD manages:

- AWS Load Balancer Controller Helm release
- Kubernetes ServiceAccount
- Controller Deployment
- Controller RBAC
- Controller configuration

Application Helm charts manage:

- Kubernetes Ingress resources

The controller then creates and reconciles AWS ALB/NLB resources.

## Authentication

This implementation uses Amazon EKS Pod Identity.

The IAM role trusts:

pods.eks.amazonaws.com

No long-lived AWS access keys are stored in Kubernetes.

## Cluster

Current development cluster:

- Cluster: lr-saas-dev-eks
- Region: us-east-1
- Kubernetes: 1.33

## Upgrade process

When upgrading the AWS Load Balancer Controller:

1. Review upstream release notes.
2. Review IAM policy changes.
3. Update iam-policy.json.
4. Update the Argo CD Helm chart version.
5. Validate CRD changes.
6. Deploy to development.
7. Validate existing Ingress resources.
8. Promote to staging.
9. Promote to production.

Do not manually modify IAM resources created by Terraform.
Do not manually install the controller with Helm in production.
