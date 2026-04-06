data "aws_route53_zone" "domain" {
  name = var.DOMAIN
}

resource "aws_route53_record" "domain" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "${local.domain_prefix}${var.DOMAIN}"
  type    = "A"
  ttl     = 300
  records = [one(linode_instance.server.ipv4)]
}

resource "aws_route53_record" "subdomains" {
  for_each = toset(local.subdomains)

  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "${local.domain_prefix}${each.value}.${var.DOMAIN}"
  type    = "A"
  ttl     = 300
  records = [one(linode_instance.server.ipv4)]
}
