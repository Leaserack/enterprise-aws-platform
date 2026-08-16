# AWS VPC Module

Reusable VPC module for the LR SaaS AWS platform.

## Module naming

Resources use the following convention:

`<name_prefix>-<environment>-<resource>`

Example:

`lr-saas-dev-vpc`

## Supported environments

- dev
- stage
- prod

## Inputs

| Variable | Type | Required |
|---|---|---|
| name_prefix | string | yes |
| environment | string | yes |
| vpc_cidr | string | yes |
| availability_zones | list(string) | yes |
| public_subnet_cidrs | list(string) | yes |
| private_subnet_cidrs | list(string) | yes |
| enable_nat_gateway | bool | no |
| single_nat_gateway | bool | no |

## Outputs

- vpc_id
- vpc_arn
- vpc_cidr
- vpc_name