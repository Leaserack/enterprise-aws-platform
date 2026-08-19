# ALB Module

Enterprise ALB networking and security foundation for the LR SaaS platform.

## Architecture

Internet
|
v
AWS WAF
|
v
Application Load Balancer
|
v
AWS Load Balancer Controller
|
v
Kubernetes Ingress
|
v
Kubernetes Service
|
v
Application Pods

## Responsibilities

This module provides:

- ALB security group
- Public subnet references
- Internal subnet references
- Configurable ingress CIDRs
- HTTPS-first security configuration

## AWS Load Balancer Controller

The actual Application Load Balancer is provisioned dynamically by the
AWS Load Balancer Controller when Kubernetes Ingress resources are created.

Terraform should not manually create every application ALB.

## Security

Production applications should prefer:

- HTTPS
- TLS termination
- AWS WAF
- restricted ingress
- private backend services
- security groups
- least privilege
- logging
- access monitoring

HTTP should normally be disabled unless it is explicitly required for
redirect behavior.

## Future Capabilities

The platform can later add:

- AWS WAF
- ACM
- Route 53
- access logging
- internal ALBs
- internet-facing ALBs
- IPv6
- Gateway API
- advanced routing
- rate limiting
- authentication