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

resource "aws_iam_user" "breakglass" {
  name          = "breakglass"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_service_linked_role" "config" {
  aws_service_name = "config.amazonaws.com"
}

resource "aws_iam_policy" "restricted_admin_dev" {
  count  = var.account_env == "dev" ? 1 : 0
  name   = "restricted-admin"
  policy = data.aws_iam_policy_document.restricted_admin_dev[0].json
}

resource "aws_iam_policy" "restricted_admin_read_only" {
  name   = "${var.name}-restricted-admin-read-only"
  policy = data.aws_iam_policy_document.restricted_admin_read_only.json
}

resource "aws_iam_policy" "developer_dev" {
  count  = var.account_env == "dev" ? 1 : 0
  name   = "developer"
  policy = data.aws_iam_policy_document.developer_dev[0].json
}

resource "aws_iam_policy" "developer" {
  name   = "${var.name}-developer"
  policy = data.aws_iam_policy_document.developer.json
}

resource "aws_iam_policy" "end_user" {
  name   = "${var.name}-end-user"
  policy = data.aws_iam_policy_document.end_user.json
}

resource "aws_iam_policy" "ci" {
  name   = "ci"
  policy = data.aws_iam_policy_document.ci.json
}

resource "aws_iam_policy" "breakglass" {
  name        = "breakglass"
  description = "Restricted administrative policy attached to breakglass user for required interactive intervention"
  policy      = data.aws_iam_policy_document.breakglass.json
}

resource "aws_iam_role" "restricted_admin_dev" {
  count              = var.account_env == "dev" ? 1 : 0
  name               = "restricted-admin"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role" "restricted_admin_read_only" {
  name               = "${var.name}-restricted-admin-read-only"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role" "developer_dev" {
  count              = var.account_env == "dev" ? 1 : 0
  name               = "developer"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role" "developer" {
  name               = "${var.name}-developer"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role" "end_user" {
  name               = "${var.name}-end-user"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role" "ci" {
  name               = "ci"
  assume_role_policy = data.aws_iam_policy_document.service_assume_role.json
}

resource "aws_iam_role_policy_attachment" "restricted_admin_dev" {
  count      = var.account_env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.restricted_admin_dev[0].arn
  role       = aws_iam_role.restricted_admin_dev[0].name
}

resource "aws_iam_role_policy_attachment" "restricted_admin_read_only" {
  policy_arn = aws_iam_policy.restricted_admin_read_only.arn
  role       = aws_iam_role.restricted_admin_read_only.name
}

resource "aws_iam_role_policy_attachment" "developer_dev" {
  count      = var.account_env == "dev" ? 1 : 0
  policy_arn = aws_iam_policy.developer_dev[0].arn
  role       = aws_iam_role.developer_dev[0].name
}

resource "aws_iam_role_policy_attachment" "developer" {
  policy_arn = aws_iam_policy.developer.arn
  role       = aws_iam_role.developer.name
}

resource "aws_iam_role_policy_attachment" "end_user" {
  policy_arn = aws_iam_policy.end_user.arn
  role       = aws_iam_role.end_user.name
}

resource "aws_iam_role_policy_attachment" "ci" {
  policy_arn = aws_iam_policy.ci.arn
  role       = aws_iam_role.ci.name
}

resource "aws_iam_user_policy_attachment" "breakglass" {
  policy_arn = aws_iam_policy.breakglass.arn
  user       = aws_iam_user.breakglass.name
}
