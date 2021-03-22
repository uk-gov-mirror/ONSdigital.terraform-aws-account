variable "email" {
  type        = string
  description = "The email address to associate with the root account.  Refer to this [table](https://github.com/ONSdigital/aws-terraform/blob/main/README.md#aws-accounts-list)"
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

# TODO: Remove unused variable
variable "master_account_id" {
  default = ""
}

variable "splunk_user_arn" {
  type        = string
  description = "The ARN of the splunk user used for splunk audit data ingestion"
}

variable "config_bucket" {
  type        = string
  description = "The name of the s3 bucket to be used as part of the config delivery channel when a config configuration recorder resource is present"
}

variable "config_sns_topic_arn" {
  type        = string
  description = "The ARN of the sns topic to be used as part of the config delivery channel when a config configuration recorder resource is present"
}

# TODO: Remove unused variable
variable "master_guardduty_detector_id" {
  default = ""
}

variable "s3_access_sqs_arn" {
  type        = string
  default     = ""
  description = "The optional ARN of the sqs queue used when an object lands in the splunk log delivery bucket"
}

variable "master_zone_id" {
  type        = string
  default     = ""
  description = "The optional zone Id of the ONS parent domain aws.onsdigital.uk to which control of this account's domain will be delegated "
}

variable "dns_zone" {
  type        = string
  default     = ""
  description = "The optional name of the domain/zone to create in this account. i.e. dns_zone = example.  Yields: example.aws.onsdigital.uk"
}
