# Secrets Manager Module

Enterprise AWS Secrets Manager module for the LR SaaS platform.

## Security model

The module creates the Secrets Manager secret container but does not manage the secret value.

Secret values must not be committed to Git.

Do not place secret values in:

- Terraform source files
- terraform.tfvars
- GitHub repository variables
- Terraform module variables
- README files

## Encryption

Secrets are encrypted using a customer-managed AWS KMS key.

## Naming

Secrets follow:

lr-saas/<environment>/<secret>

Examples:

lr-saas/dev/banking-api
lr-saas/prod/banking-api
lr-saas/prod/database

## Deletion

Secrets use a configurable recovery window.

Production should use a recovery window rather than immediate deletion.

## Rotation

Rotation is disabled by default.

When rotation is enabled, a rotation Lambda ARN must be provided.

## EKS integration

Applications should access secrets using AWS IAM authorization through EKS Pod Identity.

The application should not contain:

- AWS access keys
- AWS secret keys
- long-lived credentials

Expected flow:

EKS Pod
→ EKS Pod Identity
→ IAM role
→ Secrets Manager
→ KMS

## Versioning

The module will be consumed using an immutable Git tag:

```hcl
module "secret" {
  source = "git::https://github.com/Leaserack/enterprise-aws-platform.git//modules/secrets-manager?ref=secrets-manager-v1.0.0"
}