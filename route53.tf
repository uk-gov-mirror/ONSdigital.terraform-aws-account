resource "aws_route53_zone" "zone" {
  count = var.account_env == "iam" ? 0 : 1
  name  = "${var.dns_subdomain}.aws.onsdigital.uk"
}
