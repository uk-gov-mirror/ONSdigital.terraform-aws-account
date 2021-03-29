# terraform-module-aws-account
Provision AWS accounts within an organisation 

## Requirements

[Terraform 14+](https://www.terraform.io/downloads.html)

## Providers

| Name | Version |
|------|---------|
| aws | n/a |


## Account Module
Usage of the `Account` module within this repository is delimited by way of groups/team within the ONS, within files
named for the group/team.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_env | The intentional use of the account. i.e. dev, staging, production | `string` | n/a | yes |
| account\_team | The Team who will be responsible for this Account, e.g. cia, catd, etc.. | `string` | n/a | yes |
| config\_bucket | The name of the s3 bucket to be used as part of the config delivery channel when a config configuration recorder resource is present | `string` | n/a | yes |
| config\_sns\_topic\_arn | The ARN of the sns topic to be used as part of the config delivery channel when a config configuration recorder resource is present | `string` | n/a | yes |
| dns\_subdomain | The subdomain to create in this account and then delegate control to domain: `aws.onsdigital.uk.` i.e. dns_subdomain = example.  Yields: example.aws.onsdigital.uk | `string` | `""` | no |
| iam_account_id | The Id of the AWS account where user's IAM user accounts reside | `string` | n/a | yes |
| root\_account\_email | The email address to associate with the root account.  Refer to this [table](https://github.com/ONSdigital/aws-terraform/blob/main/README.md#aws-accounts-list) | `string` | n/a | yes |
| master\_zone\_id | The optional zone Id of the ONS parent domain aws.onsdigital.uk to which control of this account's domain will be delegated | `string` | `""` | no |
| name | The alias of the AWS account.  Also used as the common name for resources created as part of this module | `string` | n/a | yes |
| splunk\_logs\_sqs\_arn | The optional ARN of the sqs queue used when an object lands in the splunk log delivery bucket | `string` | `""` | no |
| splunk\_user\_arn | The ARN of the splunk user used for splunk audit data ingestion | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| account\_id | The Id of the newly created member AWS account |
| s3\_access\_bucket\_arn | The ARN of the splunk log delivery bucket  |


### Module Usage

To promote best practices such as CI/CD and least privileged, only AWS accounts provisioned for **development** purposes will 
contain roles (`restricted-admin`, `developer`) that allow users to interactively create, edit and destroy resources.

To provision an AWS account for development purposes, pass the value `dev` to the `account_env` argument. 


Provision an aws account for development purposes

**Note**
Contains administrative roles `restricted-admin` and `developer`

```terraform
module "dev" {
  source = "../"

  account_env          = "dev"
  account_team         = "cia"
  config_bucket        = "cia-config-bucket"
  config_sns_topic_arn = aws_sns_topic.splunk_topic.arn
  root_account_email   = "aws-registration.ons.000@ons.gov.uk"
  name                 = "dev"
  splunk_user_arn      = aws_iam_user.splunk_user.arn
  dns_subdomain        = "dev"
  master_zone_id       = "M4ST3RZ0N3ID"
  iam_account_id       = "012345678910"
  splunk_logs_sqs_arn  = "arn:aws:sqs:us-east-2:444455556666:queue1"
}
```

Provision an AWS account for testing, production etc...

```terraform
module "prod" {
  source = "../"

  account_env          = "prod"
  account_team         = "catd"
  config_bucket        = "catd-config-bucket"
  config_sns_topic_arn = aws_sns_topic.splunk_topic.arn
  root_account_email   = "aws-registration.ons.000@ons.gov.uk"
  name                 = "prod-account"
  splunk_user_arn      = aws_iam_user.splunk_user.arn
  dns_subdomain        = "production"
  master_zone_id       = "M4ST3RZ0N3ID"
  iam_account_id       = "012345678910"
}
```

### Module Documentation
* `aws_organizations_account.account` - Takes the `var.name` and `var.root_account_email` from the Module configuration to create an
  AWS Account, tagging it with teh `var.account_team` and `var_account_env` values. Contains a `local-exec` to sleep for
  120 seconds as AWS Accounts take some time to become ready when created
* `aws_iam_service_linked_role.config` - creates a SLR for the Config Recorder
* `aws_config_configuration_recorder.config-recorder` - uses the above SLR for Config Recorder configuration
* `aws_config_configuration_recorder_status.config-recorder-status` - This resource enables or disables the Config Recorder
  itself, and depends on the existence of the `aws_config_delivery_channel.config-delivery-channel`
* `aws_config_delivery_channel.config-delivery-channel` - The actual delivery channel for Config. Requires an S3 bucket
  in which to store configuration history, and an SNS topic to deliver Config notifications to
* `aws_s3_bucket.splunk_logs` - creates an S3 bucket resource named for the instantiation of the module, which allows access
  to a `var.splunk_user_arn`. It has a lifecycle rule set that expires objects after 60 days
* `aws_s3_bucket_public_access_block.splunk_logs` - is the Bucket Public Access Block configuration. This ensures that the
  bucket isn't set to public, or allowing public objects
* `aws_s3_bucket_notification.splunk_logs` - this manages the S3 Bucket notification config. It dictates that an SQS message
  be created for every object that is created in the S3 bucket, as it is recording events for `s3:ObjectCreated:*`
* `aws_route53_record.account-aws-onsdigital-uk-ns` - to support the usage of custom DNS records based on the Team Name,
  and being configured via the `var.dns_subdomain` option, this utilises the `var.master_zone_id` to create a Name Server
  type record in the Parent Account Hosted Zone.
* `aws_route53_zone` - creates a new Route 53 Hosted Zone, based on the `var.dns_subdomain` which is passed in, both to dictate
  if the resource should be deployed, and to provide the Name of the actual record. The creation of this Hosted Zone, which
  is configured in the `aws_route53_record.account-aws-onsdigital-uk-ns` to be a sub-domain within the `ons-digital.uk`
  domain, allows for Account-specific sub-domains to be created. Whilst this is mostly fine, it does create an expectation
  around the naming of AWS Accounts being strongly reflective of their usage - however since the created subdomains are
  based off the `var.dns_subdomain` being passed in, this is a string-only configuration of this item, so as long as there
  are no conflicts this should not present any issues
