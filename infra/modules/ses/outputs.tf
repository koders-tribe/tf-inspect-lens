output "email_identities" {
  description = "SES email identities."
  value       = keys(aws_sesv2_email_identity.this)
}

output "email_identity_arns" {
  description = "ARNs of SES email identities."
  value = {
    for email, identity in aws_sesv2_email_identity.this :
    email => identity.arn
  }
}

output "domain_identity" {
  description = "SES domain identity, if created."
  value       = try(aws_sesv2_email_identity.domain[0].email_identity, null)
}

output "domain_identity_arn" {
  description = "ARN of the SES domain identity, if created."
  value       = try(aws_sesv2_email_identity.domain[0].arn, null)
}

output "dkim_tokens" {
  description = "DKIM tokens to publish as CNAMEs if Route53 is not managed here."
  value       = try(aws_sesv2_email_identity.domain[0].dkim_signing_attributes[0].tokens, [])
}

output "all_identity_arns" {
  description = "Email and domain identity ARNs for IAM."
  value = compact(concat(
    values({
      for email, identity in aws_sesv2_email_identity.this :
      email => identity.arn
    }),
    [try(aws_sesv2_email_identity.domain[0].arn, null)]
  ))
}
