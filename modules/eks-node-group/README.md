# EKS Managed Node Group Module

Enterprise EKS managed node group module for the LR SaaS platform.

## Architecture

EKS Cluster
|
+-- Private Subnets
|
+-- Managed Node Group
    |
    +-- EC2 Worker Nodes
    |
    +-- Kubernetes Pods

## Security

Worker nodes are deployed into private subnets.

The module consumes an IAM node role created by the platform IAM module.

No IAM roles are created inside this module.

## Capacity

Production-style defaults:

- ON_DEMAND capacity
- Multiple worker nodes
- Minimum 3 nodes
- Desired 3 nodes
- Maximum 6 nodes
- Multiple Availability Zones

## Availability

The node group must span at least two private subnets.

For the banking platform, production workloads should use multiple Availability Zones.

## Updates

EKS Managed Node Groups are used so AWS manages node lifecycle and Kubernetes version updates.

The update configuration limits the number of unavailable nodes during updates.

## Workloads

Application workloads should use:

- Kubernetes requests and limits
- PodDisruptionBudgets
- Horizontal Pod Autoscaling
- Topology spread constraints
- Anti-affinity where appropriate
- Dedicated node groups for specialized workloads

These controls will be configured at the Kubernetes workload layer.

## Spot

SPOT capacity should not be used for critical stateful workloads.

It can be introduced later for:

- Batch workloads
- CI runners
- Non-critical workers
- Fault-tolerant processing

## Versioning

This module is consumed using an immutable Git tag:

module "eks_node_group" {
  source = "git::https://github.com/Leaserack/enterprise-aws-platform.git//modules/eks-node-group?ref=eks-node-group-v1.0.0"
}