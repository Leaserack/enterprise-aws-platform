# ACM Module

Enterprise AWS Certificate Manager module for the LR SaaS platform.

## Features

- DNS validated ACM certificates
- SAN support
- DNS validation records
- Create-before-destroy lifecycle
- Environment-aware tagging
- Configurable validation timeout

## Validation

Only DNS validation is supported.

The Route 53 hosted zone must already exist.

## Architecture

Route 53 Hosted Zone
        |
        v
ACM DNS Validation
        |
        v
ACM Certificate
        |
        v
Application Load Balancer

## Naming

Certificate resources use:

lr-saas-<environment>-acm

## Security

DNS validation is preferred over email validation for automated infrastructure.

Private keys are managed by AWS ACM and are not exposed to Terraform.

## Versioning

The module is consumed using an immutable Git tag:

module "acm" {
  source = "git::https://github.com/Leaserack/enterprise-aws-platform.git//modules/acm?ref=acm-v1.0.0"
}