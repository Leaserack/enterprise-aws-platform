# S3 Module

Enterprise AWS S3 bucket module for the LR SaaS platform.

## Security defaults

- Private bucket
- S3 Block Public Access
- BucketOwnerEnforced
- SSE-KMS
- S3 Bucket Keys
- Versioning enabled
- HTTPS-only access
- Lifecycle management
- `force_destroy = false`

## Naming

Buckets follow:

lr-saas-<environment>-<purpose>-<account-id>

Examples:

lr-saas-dev-appdata-381549359906
lr-saas-prod-artifacts-381549359906

## Encryption

The bucket uses a customer-managed KMS key.

The KMS key ARN is provided by the environment and is never hard-coded in the module.

## Object Lock

Object Lock is disabled by default.

Enable it only for data requiring WORM/retention semantics.

Object Lock must be enabled when the bucket is created and should not be enabled casually for ordinary application storage.

## Access

No public access is permitted by default.

Applications should access S3 using IAM roles / EKS Pod Identity rather than static credentials.

## Transport security

The bucket policy denies requests made without TLS.

## Lifecycle

Noncurrent object versions and incomplete multipart uploads are automatically cleaned according to configured retention periods.

## Production

The module does not dynamically configure Terraform `prevent_destroy`.

Production deletion protection should be enforced through environment-level configuration and CI/CD approval controls.

`force_destroy` remains disabled.

## Versioning

This module will later be consumed using an immutable Git tag:

```hcl
module "s3" {
  source = "git::https://github.com/Leaserack/enterprise-aws-platform.git//modules/s3?ref=s3-v1.0.0"
}