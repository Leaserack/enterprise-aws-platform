# SSM Parameter Store Module

Enterprise AWS Systems Manager Parameter Store module for the LR SaaS platform.

## Use Cases

Use Parameter Store for:

- Application configuration
- Environment configuration
- Feature flags
- URLs
- Non-secret runtime configuration

Use AWS Secrets Manager for:

- Passwords
- API credentials
- Database credentials
- Tokens
- Secrets requiring rotation

## Naming

Parameters follow:

/lr-saas/<environment>/<parameter>

Examples:

/lr-saas/dev/application/api-url
/lr-saas/dev/application/log-level
/lr-saas/prod/application/api-url

## Security

SecureString parameters can use a customer-managed KMS key.

Do not commit sensitive parameter values to Git.

Applications should use IAM-based access rather than AWS access keys.

## EKS Integration

Expected model:

EKS Pod
→ EKS Pod Identity
→ IAM Role
→ SSM Parameter Store

## Versioning

This module is consumed using immutable Git tags.

Example:

module "parameter" {
  source = "git::https://github.com/Leaserack/enterprise-aws-platform.git//modules/parameter-store?ref=parameter-store-v1.0.0"
}