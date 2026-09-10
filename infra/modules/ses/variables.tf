variable "emails" {
  description = "SES email identities to verify (click the AWS verification mail)."
  type        = list(string)
  default     = []
}

variable "domain" {
  description = "Optional sending domain to verify (preferred over a single mailbox). Leave empty to skip."
  type        = string
  default     = ""
}

variable "route53_zone_id" {
  description = "If set, create DKIM CNAME records in this public hosted zone."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
  default     = {}
}
