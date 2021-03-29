provider "aws" {
  region                      = "eu-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_force_path_style         = true
  access_key                  = "access_key"
  secret_key                  = "secret_key"

  endpoints {
    s3 = "http://localhost:4572"
  }
}

module "dev" {
  source = "../"

  account_env          = "dev"
  account_team         = "cia"
  config_bucket        = "cia-config-bucket"
  config_sns_topic_arn = aws_sns_topic.splunk_topic.arn
  root_account_email   = "aws-registration.ons.000@ons.gov.uk"
  name                 = "dev"
  splunk_user_arn      = aws_iam_user.splunk_user.arn
  dns_subdomain        = "dev"
  master_zone_id       = "M4ST3RZ0N3ID"
  iam_account_id       = "012345678910"
  splunk_logs_sqs_arn  = "arn:aws:sqs:us-east-2:444455556666:queue1"
}

module "test" {
  source = "../"

  account_env          = "test"
  account_team         = "catd"
  config_bucket        = "catd-config-bucket"
  config_sns_topic_arn = aws_sns_topic.splunk_topic.arn
  root_account_email   = "aws-registration.ons.000@ons.gov.uk"
  name                 = "test"
  splunk_user_arn      = aws_iam_user.splunk_user.arn
  dns_subdomain        = "test"
  master_zone_id       = "M4ST3RZ0N3ID"
  iam_account_id       = "012345678910"
}

resource "aws_iam_user" "splunk_user" {
  name = "splunk-user"
}

resource "aws_sns_topic" "splunk_topic" {
  name = "splunk-topic"
}

