# LR SaaS VPC Module

Reusable AWS VPC module for the LR SaaS platform.

## Module Version

Current release:

`vpc-v1.1.0`

## Naming

All resources follow:

`<name_prefix>-<environment>-<resource>`

Example:

`lr-saas-dev-vpc`

## Architecture

The module supports:

- VPC
- Internet Gateway
- Public subnets
- Private subnets
- Public route table
- Private route tables
- NAT Gateway
- Elastic IPs
- S3 Gateway VPC endpoint
- DynamoDB Gateway VPC endpoint
- DNS support
- DNS hostnames

## Multi-AZ Design

The module supports multiple Availability Zones.

Production should normally use:

```hcl
single_nat_gateway = false