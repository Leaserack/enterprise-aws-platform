variable "route53_zone_id" {
  description = "Route 53 hosted zone ID used for ACM DNS validation."
  type        = string

  validation {
    condition     = can(regex("^Z[A-Z0-9]+$", var.route53_zone_id))
    error_message = "route53_zone_id must be a valid Route 53 hosted zone ID."
  }
}