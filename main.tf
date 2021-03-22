# TODO: Unnecessary perhaps?  Discuss removing
provider "aws" {
  alias  = "ons"
  region = "eu-west-2"
}

resource "aws_organizations_account" "account" {
  provider = aws.ons
  name     = var.name
  email    = var.email

  tags = {
    team = var.account_team
    env  = var.account_env
  }

  provisioner "local-exec" {
    # AWS accounts aren't quite ready on creation, arbitrary pause before we provision resources inside it
    command = "sleep 120"
  }
}

provider "aws" {
  region = "eu-west-2"

  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.account.id}:role/OrganizationAccountAccessRole"
  }
}

resource "aws_iam_service_linked_role" "config" {
  aws_service_name = "config.amazonaws.com"
}

resource "aws_config_configuration_recorder" "config-recorder" {
  name     = "config-recorder-${aws_organizations_account.account.id}"
  role_arn = aws_iam_service_linked_role.config.arn

  recording_group {
    include_global_resource_types = true
  }
}

resource "aws_config_configuration_recorder_status" "config-recorder-status" {
  depends_on = [aws_config_delivery_channel.config-delivery-channel]

  name       = aws_config_configuration_recorder.config-recorder.name
  is_enabled = true
}

resource "aws_config_delivery_channel" "config-delivery-channel" {
  depends_on = [aws_config_configuration_recorder.config-recorder]

  name           = "config-delivery-channel-${aws_organizations_account.account.id}"
  s3_bucket_name = var.config_bucket
  sns_topic_arn  = var.config_sns_topic_arn
}

resource "aws_s3_bucket" "s3-access" {
  count = var.s3_access_sqs_arn != "" ? 1 : 0

  bucket = "${var.name}-s3-access"
  acl    = "log-delivery-write"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "SplunkAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.splunk_user_arn}"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.name}-s3-access/*"
    }
  ]
}
POLICY

  lifecycle_rule {
    id      = "log"
    enabled = true

    expiration {
      days = 60
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3-access" {
  count = var.s3_access_sqs_arn != "" ? 1 : 0

  bucket                  = aws_s3_bucket.s3-access[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "s3-access" {
  count = var.s3_access_sqs_arn != "" ? 1 : 0

  bucket = aws_s3_bucket.s3-access[0].id

  queue {
    queue_arn = var.s3_access_sqs_arn
    events    = ["s3:ObjectCreated:*"]
  }
}

# TODO: Refactor to include additional NS records
resource "aws_route53_record" "account-aws-onsdigital-uk-ns" {
  count = var.dns_zone == "" ? 0 : 1

  provider = aws.ons
  zone_id  = var.master_zone_id
  name     = "${var.dns_zone}.aws.onsdigital.uk."
  type     = "NS"
  ttl      = "300"

  records = aws_route53_zone.account-aws-onsdigital-uk[0].name_servers
}

resource "aws_route53_zone" "account-aws-onsdigital-uk" {
  count = var.dns_zone == "" ? 0 : 1

  name = "${var.dns_zone}.aws.onsdigital.uk"
}

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 14
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  max_password_age               = 30
  hard_expiry                    = false
  allow_users_to_change_password = true
  password_reuse_prevention      = 10
}
