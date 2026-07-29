###############################################################################
# SES Emails Identities
###############################################################################

variable "emails" {

  description = "Verified SES email identities."

  type = list(string)

}