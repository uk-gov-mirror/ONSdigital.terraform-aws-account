resource "aws_s3_bucket" "state" {
  bucket = "${var.name}-terraform-state-${var.account_env}"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  dynamic "logging" {
    for_each = length(var.logging_bucket) > 0 ? [1] : []
    content {
      target_bucket = var.logging_bucket
      target_prefix = "s3/${var.name}-terraform-state-${var.account_env}/"
    }
  }
}

resource "aws_s3_bucket" "config" {
  bucket = "${var.name}-config-recorder-${var.account_env}"
  acl    = "log-delivery-write"

  lifecycle {
    prevent_destroy = true
  }

  lifecycle_rule {
    id      = "log"
    enabled = true

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  dynamic "logging" {
    for_each = length(var.logging_bucket) > 0 ? [1] : []
    content {
      target_bucket = var.logging_bucket
      target_prefix = "s3/${var.name}-config-recorder/"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "state_acl" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "config" {
  bucket = aws_s3_bucket.config.id
  policy = data.aws_iam_policy_document.config.json
}

resource "aws_s3_bucket_public_access_block" "config_acl" {
  bucket                  = aws_s3_bucket.config.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
