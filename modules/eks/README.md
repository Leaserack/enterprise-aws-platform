# EKS Module

Enterprise Amazon EKS cluster module for the LR SaaS platform.

## Architecture

VPC
|
+-- Private Subnets
|
+-- EKS Control Plane
|
+-- EKS Managed Node Groups
|
+-- Kubernetes Workloads

## Security

The module supports:

- Private EKS API endpoint
- Controlled public API access
- EKS control-plane audit logging
- KMS encryption for Kubernetes secrets
- Dedicated EKS security group
- IAM-based cluster authentication

## IAM

The module consumes IAM role ARNs created by the IAM module.

It does not create IAM roles internally.

Expected dependencies:

IAM
|
+-- EKS Cluster Role
|
+-- EKS Node Role
|
+-- Pod Identity Roles

## Networking

The EKS control plane is deployed using the supplied private subnets.

At least two private subnets are required.

The production platform should use multiple Availability Zones.

## Kubernetes Authentication

The cluster uses:

API_AND_CONFIG_MAP

for the initial platform implementation.

Access management will later be handled through EKS access entries and Kubernetes RBAC.

## Workload Identity

Applications should use EKS Pod Identity for AWS API access.

Do not place:

- AWS access keys
- AWS secret keys
- long-lived credentials

inside Kubernetes workloads.

## Encryption

Kubernetes Secrets are encrypted using the supplied customer-managed KMS key.

## Logging

The following control-plane logs can be enabled:

- API
- Audit
- Authenticator
- Controller Manager
- Scheduler

## Add-ons

EKS add-ons will be managed separately.

Expected add-ons include:

- VPC CNI
- CoreDNS
- kube-proxy
- EBS CSI Driver

## Platform

After the EKS cluster is deployed:

EKS
|
+-- EKS Add-ons
|
+-- AWS Load Balancer Controller
|
+-- Helm
|
+-- Argo CD
|
+-- Application
|
+-- Prometheus
|
+-- Grafana
|
+-- OpenTelemetry

## Versioning

This module is consumed using an immutable Git tag:

module "eks" {
  source = "git::https://github.com/Leaserack/enterprise-aws-platform.git//modules/eks?ref=eks-v1.0.0"
}