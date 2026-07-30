###############################################################################
# Existing SES Email Identities
###############################################################################

resource "aws_sesv2_email_identity" "this" {

  for_each = toset(var.emails)  

  email_identity = each.value

}