# ECR Module

Enterprise Amazon ECR repository module for the LR SaaS platform.

## Features

- Private ECR repository
- Customer-managed KMS encryption
- Immutable image tags by default
- Image scanning on push
- Lifecycle management
- Environment-aware naming
- Mandatory platform tags
- Force deletion disabled by default

## Naming

Repositories follow:

lr-saas-<environment>-<repository>

Example:

lr-saas-dev-banking-api
lr-saas-prod-banking-api

## Security

The repository uses a customer-managed KMS key.

Image tags are immutable by default.

Image scanning on push is enabled by default.

Repository deletion with existing images is disabled by default.

## Container deployment

The preferred deployment reference is an immutable image tag or digest.

Do not use `latest` for production deployments.

Example:

```text
123456789012.dkr.ecr.us-east-1.amazonaws.com/lr-saas-prod-banking-api@sha256:<digest>