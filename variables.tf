variable "root_account_email" {
  type        = string
  description = "The email address to associate with the root account.  Refer to this [table](https://github.com/ONSdigital/aws-terraform/blob/main/README.md#aws-accounts-list)"

  validation {
    condition     = length(regexall("aws-registration.ons.\\d{3}@ons.gov.uk", var.root_account_email)) == 1
    error_message = "The `root_account_email` value is not valid.  See:https://github.com/ONSdigital/aws-terraform/blob/main/README.md#aws-accounts-list for valid values."
  }
}

variable "name" {
  type        = string
  description = "The alias of the AWS account.  Also used as the common name for resources created as part of this module"
}

variable "account_team" {
  type        = string
  description = "The Team who will be responsible for this Account, e.g. cia, catd, etc.."
}

variable "account_env" {
  type        = string
  description = "The intentional use of the account. i.e. dev, staging, production"
}

variable "splunk_user_arn" {
  type        = string
  description = "The ARN of the splunk user used for splunk audit data ingestion"

  validation {
    condition     = length(regexall("^arn:(?P<Partition>[^:\n]*):(?P<Service>[^:\n]*):(?P<Region>[^:\n]*):(?P<AccountID>[^:\n]*):(?P<Ignore>(?P<ResourceType>[^:\\/\n]*)[:\\/])?(?P<Resource>.*)$", var.splunk_user_arn)) == 1
    error_message = "The `splunk_user_arn` value must be a valid ARN. See: https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html for more information."
  }
}

variable "config_bucket" {
  type        = string
  description = "The name of the s3 bucket to be used as part of the config delivery channel when a config configuration recorder resource is present"
}

variable "config_sns_topic_arn" {
  type        = string
  description = "The ARN of the sns topic to be used as part of the config delivery channel when a config configuration recorder resource is present"

  validation {
    condition     = length(regexall("^arn:(?P<Partition>[^:\n]*):(?P<Service>[^:\n]*):(?P<Region>[^:\n]*):(?P<AccountID>[^:\n]*):(?P<Ignore>(?P<ResourceType>[^:\\/\n]*)[:\\/])?(?P<Resource>.*)$", var.config_sns_topic_arn)) == 1
    error_message = "The `config_sns_topic_arn` value must be a valid ARN. See: https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html for more information."
  }
}

variable "splunk_logs_sqs_arn" {
  type        = string
  default     = ""
  description = "The optional ARN of the sqs queue used when an object lands in the splunk log delivery bucket"

  validation {
    condition     = length(regexall("^arn:(?P<Partition>[^:\n]*):(?P<Service>[^:\n]*):(?P<Region>[^:\n]*):(?P<AccountID>[^:\n]*):(?P<Ignore>(?P<ResourceType>[^:\\/\n]*)[:\\/])?(?P<Resource>.*)$", var.splunk_logs_sqs_arn)) + length(regexall("^$", var.splunk_logs_sqs_arn)) == 1
    error_message = "The `splunk_logs_sqs_arn` value must be a valid ARN. See: https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html for more information."
  }
}

variable "master_zone_id" {
  type        = string
  description = "The optional zone Id of the ONS parent domain aws.onsdigital.uk to which control of this account's domain will be delegated"

  validation {
    condition     = length(regexall("\\w{8,32}", var.master_zone_id)) == 1
    error_message = "Route53 zone Ids are alpha numeric and must be between 8-32 characters long."
  }
}

variable "dns_subdomain" {
  type        = string
  description = "The subdomain to create in this account and then delegate control to domain: `aws.onsdigital.uk.` i.e. dns_subdomain = example.  Yields: example.aws.onsdigital.uk"

  validation {
    condition     = length(regexall("(?:.aws.onsdigital.uk)", var.dns_subdomain)) < 1
    error_message = "Do not include `.aws.onsdigital.uk`. Please refer to README."
  }
}

variable "iam_account_id" {
  type        = string
  description = "The Id of the AWS account where user's IAM user accounts reside"

  validation {
    condition     = length(regexall("\\d{12}", var.iam_account_id)) == 1
    error_message = "AWS account numbers are 12 digits long."
  }
}
