resource "aws_config_configuration_recorder" "config_recorder" {
  name     = "config-recorder-${aws_organizations_account.account.id}"
  role_arn = aws_iam_service_linked_role.config.arn

  recording_group {
    include_global_resource_types = true
  }
}

resource "aws_config_configuration_recorder_status" "config_recorder_status" {
  depends_on = [aws_config_delivery_channel.config_delivery_channel]

  name       = aws_config_configuration_recorder.config_recorder.name
  is_enabled = true
}

resource "aws_config_delivery_channel" "config_delivery_channel" {
  depends_on = [aws_config_configuration_recorder.config_recorder]

  name           = "config-delivery-channel-${aws_organizations_account.account.id}"
  s3_bucket_name = aws_s3_bucket.config.id
  sns_topic_arn  = aws_sns_topic.config.arn

  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
}
