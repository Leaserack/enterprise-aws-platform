# KMS Module

Enterprise AWS KMS customer-managed key module for the LR SaaS platform.

## Purpose

Creates a customer-managed AWS KMS key and alias with:

- Automatic rotation
- Configurable deletion window
- Explicit key policy
- Separate administrator and user permissions
- Optional `kms:ViaService` restriction
- Optional multi-Region primary key
- Environment-aware naming
- Tags
- Optional Terraform deletion protection

## Naming

Resources follow:

lr-saas-<environment>-<purpose>

Examples:

lr-saas-dev-eks
lr-saas-dev-secrets
lr-saas-prod-data

Aliases:

alias/lr-saas-dev-eks
alias/lr-saas-dev-secrets
alias/lr-saas-prod-data

## Security model

Key administrators and key users are separated.

Key administrators manage:

- Key policy
- Rotation
- Description
- Tags
- Deletion scheduling

Key users receive only cryptographic usage permissions.

Where applicable, `kms:ViaService` can restrict key usage to specific AWS services.

## Multi-Region

Multi-Region keys are disabled by default.

Enable them only where disaster recovery, cross-Region encryption, or another explicit requirement justifies their use.

Primary Region:

us-east-1

DR Region:

us-west-2

Multi-Region key policies are maintained independently for primary and replica keys.

## Lifecycle

`prevent_destroy` is configurable.

Recommended:

Development:

prevent_destroy = false

Production:

prevent_destroy = true

KMS deletion uses a configurable deletion window and should not be treated as an immediate operation.

## Rotation

Automatic rotation is enabled by default.

AWS KMS retains previous cryptographic material so existing ciphertext remains decryptable after rotation.

## Sensitive information

Do not place passwords, tokens, credentials, customer data, or other sensitive information in:

- KMS descriptions
- KMS tags
- Terraform variables committed to Git

## Versioning

The module will be consumed using immutable Git tags.

Example:

```hcl
module "kms" {
  source = "git::https://github.com/Leaserack/enterprise-aws-platform.git//modules/kms?ref=kms-v1.0.0"
}