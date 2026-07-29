###############################################################################
# SES Email Identities
###############################################################################

output "email_identities" {

  description = "SES email identities."

  value = keys(aws_sesv2_email_identity.this)

}

###############################################################################
# SES Email Identity ARNs
###############################################################################

output "email_identity_arns" {

  description = "ARNs of SES email identities."

  value = {
    for email, identity in aws_sesv2_email_identity.this :
    email => identity.arn
  }

}