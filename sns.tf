resource "aws_sns_topic" "config" {
  name = "${var.name}-config-recorder"
}
