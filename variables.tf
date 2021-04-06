variable "root_account_email" {
  type        = string
  description = "The email address to associate with the root account.  Refer to this [table](https://github.com/ONSdigital/aws-terraform/blob/main/README.md#aws-accounts-list)"

  validation {
    condition     = length(regexall("aws.d.registration.\\d{3}@ons.gov.uk", var.root_account_email)) == 1
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

variable "logging_bucket" {
  type        = string
  default     = ""
  description = "The name of the logging bucket to export account level s3 logs"
}
