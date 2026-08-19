# EKS Add-ons Module

Enterprise AWS-managed EKS add-ons for the LR SaaS platform.

## Managed Add-ons

This module manages:

- VPC CNI
- CoreDNS
- kube-proxy
- AWS EBS CSI Driver

## Architecture

EKS Cluster
|
+-- VPC CNI
|     |
|     +-- Pod networking
|
+-- CoreDNS
|     |
|     +-- Kubernetes DNS
|
+-- kube-proxy
|     |
|     +-- Kubernetes service networking
|
+-- EBS CSI
      |
      +-- Persistent EBS volumes

## Security

The add-ons are managed through AWS EKS.

Workload IAM is provided through IAM roles rather than static AWS credentials.

The EBS CSI driver should use an IAM role with only the permissions required for EBS operations.

The VPC CNI should use a dedicated IAM role where required.

## Version Management

Add-on versions are supplied by the environment.

This allows:

- Explicit version pinning
- Controlled upgrades
- Environment-specific testing
- Safer production releases
- Rollback to a previously supported version

## Upgrade Strategy

Kubernetes upgrades should follow:

1. Validate add-on compatibility.
2. Update add-on versions in a controlled change.
3. Run Terraform plan.
4. Review changes.
5. Apply.
6. Validate node and pod health.

Do not automatically upgrade production add-ons without validation.

## EKS Platform

After the core add-ons:

EKS
|
+-- VPC CNI
+-- CoreDNS
+-- kube-proxy
+-- EBS CSI
|
+-- AWS Load Balancer Controller
|
+-- Helm
|
+-- Argo CD
|
+-- Application
|
+-- Observability