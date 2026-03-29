data "aws_route53_zone" "domain" {
  name = local.domain
}

resource "aws_route53_record" "domain" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "${local.domain_prefix}${local.domain}"
  type    = "A"
  ttl     = 300
  records = [one(linode_instance.server.ipv4)]
}

resource "aws_route53_record" "subdomains" {
  for_each = toset(local.subdomains)

  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "${local.domain_prefix}${each.value}.${local.domain}"
  type    = "A"
  ttl     = 300
  records = [one(linode_instance.server.ipv4)]
}
