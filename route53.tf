resource "aws_route53_zone" "zone" {
  count = var.account_env == "iam" ? 0 : 1
  name  = "${var.dns_subdomain}.aws.onsdigital.uk"
}

resource "aws_route53_record" "account_aws_onsdigital_uk_ns" {
  count   = var.account_env == "iam" ? 0 : 1
  zone_id = var.master_zone_id
  name    = "${aws_route53_zone.zone[0].name}."
  type    = "NS"
  ttl     = "300"

  records = aws_route53_zone.zone[0].name_servers
}
