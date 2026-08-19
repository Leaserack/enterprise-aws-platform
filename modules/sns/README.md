# SNS Module

Enterprise Amazon SNS module for the LR SaaS platform.

## Features

- Standard SNS topics
- FIFO topic support
- Optional customer-managed KMS encryption
- Subscription support
- Environment-aware naming
- Common platform tagging

## Naming

Topics follow:

lr-saas-<environment>-<purpose>

Examples:

lr-saas-dev-alerts
lr-saas-prod-alerts

## Security

SNS topics can use customer-managed KMS encryption.

Production notification topics should use encryption where required.

Subscriptions should follow least-privilege access.

## Platform Usage

SNS can be used for:

- CloudWatch alarms
- Infrastructure alerts
- Application alerts
- Operational notifications
- Incident notifications

## EKS

Application workloads should publish to SNS using IAM authorization through EKS Pod Identity.

Do not place AWS credentials inside Kubernetes workloads.

## Versioning

The module is consumed using immutable Git tags:

module "sns" {
  source = "git::https://github.com/Leaserack/enterprise-aws-platform.git//modules/sns?ref=sns-v1.0.0"
}