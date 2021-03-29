data "aws_iam_policy_document" "assume_role" {
  statement {
    sid    = "AssumeRole"
    effect = "Allow"

    principals {
      identifiers = ["arn:aws:iam::${var.iam_account_id}:root"]
      type        = "AWS"
    }

    condition {
      test     = "BoolIfExists"
      values   = ["true"]
      variable = "aws:MultiFactorAuthPresent"
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "splunk_logs" {
  statement {
    sid    = "SplunkAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [var.splunk_user_arn]
    }

    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.name}-s3-access/*"]
  }
}

data "aws_iam_policy_document" "restricted_admin_dev" {
  statement {
    sid    = "RestrictedAdminDev"
    effect = "Allow"

    actions = [
      "acm:*",
      "automation:*",
      "aws-marketplace:*",
      "cloudformation:*",
      "cloudtrail:*",
      "cloudwatch:*",
      "config:*",
      "dms:*",
      "dynamodb:*",
      "ecr:*",
      "ecs:*",
      "ec2:*",
      "elasticache:*",
      "elasticloadbalancing:*",
      "events:*",
      "glacier:*",
      "health:*",
      "inspector:*",
      "kinesis:*",
      "kms:*",
      "lambda:*",
      "logs:*",
      "rds:*",
      "route53:*",
      "route53domains:*",
      "s3:*",
      "secretsmanager:*",
      "ses:*",
      "shield:*",
      "sns:*",
      "sqs:*",
      "ssm:*",
      "sts:*",
      "swf:*",
      "support:*",
      "trustedadvisor:*",
      "waf:*",
      "waf-regional:*"
    ]

    resources = []
  }
}

data "aws_iam_policy_document" "restricted_admin_read_only" {
  statement {
    sid    = "RestrictedAdminOnly"
    effect = "Allow"

    actions = [
      "acm:DescribeCertificate",
      "acm:GetCertificate",
      "acm:ListCertificates",
      "acm:ListTagsForCertificate",
      "apigateway:GET",
      "application-autoscaling:Describe*",
      "appstream:Describe*",
      "appstream:Get*",
      "appstream:List*",
      "autoscaling:Describe*",
      "cloudformation:Describe*",
      "cloudformation:Get*",
      "cloudformation:List*",
      "cloudfront:Get*",
      "cloudfront:List*",
      "cloudsearch:Describe*",
      "cloudsearch:List*",
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetEventSelectors",
      "cloudtrail:GetTrailStatus",
      "cloudtrail:LookupEvents",
      "cloudtrail:ListTags",
      "cloudtrail:ListPublicKeys",
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "codebuild:BatchGetBuilds",
      "codebuild:BatchGetProjects",
      "codebuild:List*",
      "codecommit:BatchGetRepositories",
      "codecommit:Get*",
      "codecommit:GitPull",
      "codecommit:List*",
      "codedeploy:Batch*",
      "codedeploy:Get*",
      "codedeploy:List*",
      "config:Deliver*",
      "config:Describe*",
      "config:Get*",
      "config:List*",
      "directconnect:Describe*",
      "dms:Describe*",
      "dms:List*",
      "dynamodb:BatchGetItem",
      "dynamodb:DescribeLimits",
      "dynamodb:DescribeReservedCapacity",
      "dynamodb:DescribeReservedCapacityOfferings",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:ListTables",
      "dynamodb:ListTagsOfResource",
      "dynamodb:Query",
      "dynamodb:Scan",
      "ec2:Describe*",
      "ec2:GetConsoleOutput",
      "ec2:GetConsoleScreenshot",
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:Describe*",
      "ecr:Get*",
      "ecr:List*",
      "ecs:Describe*",
      "ecs:List*",
      "elasticache:Describe*",
      "elasticache:List*",
      "events:DescribeRule",
      "events:ListRuleNamesByTarget",
      "events:ListRules",
      "events:ListTargetsByRule",
      "events:TestEventPattern",
      "firehose:Describe*",
      "firehose:List*",
      "glacier:ListVaults",
      "glacier:DescribeVault",
      "glacier:GetDataRetrievalPolicy",
      "glacier:GetVaultAccessPolicy",
      "glacier:GetVaultLock",
      "glacier:GetVaultNotifications",
      "glacier:ListJobs",
      "glacier:ListMultipartUploads",
      "glacier:ListParts",
      "glacier:ListTagsForVault",
      "glacier:DescribeJob",
      "glacier:GetJobOutput",
      "health:Describe*",
      "health:Get*",
      "health:List*",
      "iam:GenerateCredentialReport",
      "iam:GenerateServiceLastAccessedDetails",
      "iam:Get*",
      "iam:List*",
      "inspector:Describe*",
      "inspector:Get*",
      "inspector:List*",
      "inspector:LocalizeText",
      "inspector:PreviewAgentsForResourceGroup",
      "kinesisanalytics:DescribeApplication",
      "kinesisanalytics:DiscoverInputSchema",
      "kinesisanalytics:GetApplicationState",
      "kinesisanalytics:ListApplications",
      "kinesis:Describe*",
      "kinesis:Get*",
      "kinesis:List*",
      "kms:Describe*",
      "kms:Get*",
      "kms:List*",
      "lambda:List*",
      "lambda:Get*",
      "logs:Describe*",
      "logs:Get*",
      "logs:FilterLogEvents",
      "logs:TestMetricFilter",
      "organizations:Describe*",
      "organizations:List*",
      "polly:Describe*",
      "polly:Get*",
      "polly:List*",
      "polly:SynthesizeSpeech",
      "rekognition:CompareFaces",
      "rekognition:DetectFaces",
      "rekognition:DetectLabels",
      "rekognition:List*",
      "rekognition:SearchFaces",
      "rekognition:SearchFacesByImage",
      "rds:Describe*",
      "rds:ListTagsForResource",
      "redshift:Describe*",
      "redshift:ViewQueriesInConsole",
      "route53:Get*",
      "route53:List*",
      "route53domains:CheckDomainAvailability",
      "route53domains:GetDomainDetail",
      "route53domains:GetOperationDetail",
      "route53domains:ListDomains",
      "route53domains:ListOperations",
      "route53domains:ListTagsForDomain",
      "s3:Get*",
      "s3:List*",
      "sdb:GetAttributes",
      "sdb:List*",
      "sdb:Select*",
      "secretsmanager:Get*",
      "secretsmanager:DescribeSecret",
      "secretsmanager:List*",
      "ses:Get*",
      "ses:List*",
      "shield:Describe*",
      "shield:List*",
      "sns:Get*",
      "sns:List*",
      "sqs:GetQueueAttributes",
      "sqs:ListQueues",
      "sqs:ReceiveMessage",
      "ssm:Describe*",
      "ssm:Get*",
      "ssm:List*",
      "storagegateway:Describe*",
      "storagegateway:List*",
      "swf:Count*",
      "swf:Describe*",
      "swf:Get*",
      "swf:List*",
      "tag:Get*",
      "trustedadvisor:Describe*",
      "waf:Get*",
      "waf:List*",
      "workspaces:Describe*",
      "xray:BatchGetTraces",
      "xray:Get*"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "developer_dev" {
  statement {
    sid    = "DeveloperDev"
    effect = "Allow"

    actions = [
      "ecr:*",
      "lambda:*",
      "logs:Describe*",
      "logs:Get*",
      "logs:FilterLogEvents",
      "logs:TestMetricFilter",
      "rds:*",
      "secretsmanager:*",

    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "developer" {
  statement {
    sid    = "Developer"
    effect = "Allow"

    actions   = []
    resources = []
  }
}

data "aws_iam_policy_document" "end_user" {
  statement {
    sid    = "EndUser"
    effect = "Allow"

    actions   = []
    resources = []
  }
}
