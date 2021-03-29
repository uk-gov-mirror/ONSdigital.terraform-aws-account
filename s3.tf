resource "aws_s3_bucket" "splunk_logs" {
  count = signum(length(var.splunk_logs_sqs_arn))

  bucket = "${var.name}-s3-access"
  acl    = "log-delivery-write"

  policy = data.aws_iam_policy_document.splunk_logs.json

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

resource "aws_s3_bucket_public_access_block" "splunk_logs" {
  count = signum(length(var.splunk_logs_sqs_arn))

  bucket                  = aws_s3_bucket.splunk_logs[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "splunk_logs" {
  count = signum(length(var.splunk_logs_sqs_arn))

  bucket = aws_s3_bucket.splunk_logs[0].id

  queue {
    queue_arn = var.splunk_logs_sqs_arn
    events    = ["s3:ObjectCreated:*"]
  }
}
