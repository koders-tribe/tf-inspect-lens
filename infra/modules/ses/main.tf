resource "aws_sesv2_email_identity" "this" {
  for_each = toset(var.emails)

  email_identity = each.value
  tags           = var.tags
}

resource "aws_sesv2_email_identity" "domain" {
  count = var.domain != "" ? 1 : 0

  email_identity = var.domain
  tags           = var.tags

  dkim_signing_attributes {
    next_signing_key_length = "RSA_2048_BIT"
  }
}

# Easy DKIM always issues 3 tokens. The tokens are unknown until apply, so the
# count cannot be derived from them.
resource "aws_route53_record" "dkim" {
  count = var.domain != "" && var.route53_zone_id != "" ? 3 : 0

  zone_id = var.route53_zone_id
  name    = "${aws_sesv2_email_identity.domain[0].dkim_signing_attributes[0].tokens[count.index]}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = 300
  records = [
    "${aws_sesv2_email_identity.domain[0].dkim_signing_attributes[0].tokens[count.index]}.dkim.amazonses.com"
  ]
}
