# Route 53 Module

Enterprise AWS Route 53 module for the LR SaaS platform.

## Features

- Public or private hosted zones
- DNSSEC support for public hosted zones
- Alias records
- Standard DNS records
- Environment-aware naming and tagging
- Optional VPC association for private hosted zones

## Naming

The platform uses:

lr-saas-<environment>

The DNS domain itself is provided by the environment.

Example:

dev.example.com
prod.example.com

## ACM Integration

ACM DNS validation records can be created using Route 53.

Expected architecture:

Route 53
    |
    +-- ACM validation
    |
    +-- Application DNS
             |
             v
            ALB

## Security

Private hosted zones should be used for internal services.

Public hosted zones should contain only intentionally public DNS records.

DNSSEC can be enabled for public hosted zones.

## EKS

Later, Kubernetes DNS integration can be added through ExternalDNS.

ExternalDNS should use IAM-based authentication through EKS Pod Identity.

Do not provide AWS access keys to Kubernetes.

## Versioning

The module will be consumed using an immutable Git tag:

module "route53" {
  source = "git::https://github.com/Leaserack/enterprise-aws-platform.git//modules/route53?ref=route53-v1.0.0"
}