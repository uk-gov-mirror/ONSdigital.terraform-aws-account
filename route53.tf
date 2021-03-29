resource "aws_route53_zone" "zone" {
  name = "${var.dns_subdomain}.aws.onsdigital.uk"
}

resource "aws_route53_record" "account_aws_onsdigital_uk_ns" {
  zone_id = var.master_zone_id
  name    = "${aws_route53_zone.zone.name}."
  type    = "NS"
  ttl     = "300"

  records = aws_route53_zone.zone.name_servers
}
