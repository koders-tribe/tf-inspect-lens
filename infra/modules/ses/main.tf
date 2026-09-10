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

resource "aws_route53_record" "dkim" {
  count = var.domain != "" && var.route53_zone_id != "" ? length(aws_sesv2_email_identity.domain[0].dkim_signing_attributes[0].tokens) : 0

  zone_id = var.route53_zone_id
  name    = "${aws_sesv2_email_identity.domain[0].dkim_signing_attributes[0].tokens[count.index]}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = 300
  records = [
    "${aws_sesv2_email_identity.domain[0].dkim_signing_attributes[0].tokens[count.index]}.dkim.amazonses.com"
  ]
}
