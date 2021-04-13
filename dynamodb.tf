resource "aws_dynamodb_table" "state_lock" {
  hash_key       = "LockID"
  name           = "${var.name}-terraform-lock"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }
}
