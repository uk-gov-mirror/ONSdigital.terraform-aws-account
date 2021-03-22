# terraform-module-aws-account
Provision AWS accounts within an organisation 

## Requirements

[Terraform 12+](https://www.terraform.io/downloads.html)

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
| dns\_zone | The optional name of the domain/zone to create in this account. i.e. dns\_zone = example.  Yields: example.aws.onsdigital.uk | `string` | `""` | no |
| email | The email address to associate with the root account.  Refer to this [table](https://github.com/ONSdigital/aws-terraform/blob/main/README.md#aws-accounts-list) | `string` | n/a | yes |
| master\_account\_id | TODO: Remove unused variable | `string` | `""` | no |
| master\_guardduty\_detector\_id | TODO: Remove unused variable | `string` | `""` | no |
| master\_zone\_id | The optional zone Id of the ONS parent domain aws.onsdigital.uk to which control of this account's domain will be delegated | `string` | `""` | no |
| name | The alias of the AWS account.  Also used as the common name for resources created as part of this module | `string` | n/a | yes |
| s3\_access\_sqs\_arn | The optional ARN of the sqs queue used when an object lands in the splunk log delivery bucket | `string` | `""` | no |
| splunk\_user\_arn | The ARN of the splunk user used for splunk audit data ingestion | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| account\_id | The Id of the newly created member AWS account |
| s3\_access\_bucket\_arn | The ARN of the splunk log delivery bucket  |


### Module Usage
For example, the file `cia.tf` contains the module-usage configuration for all the CIA AWS Accounts that are deployed.
Within this file, each Account under a group/team is a call to the `Account` module. For example, the `ons-cia-sandbox`
Account module configuration looks like:

	module "sandbox-cia" {
	  source                       = "./Account"
	  email                        = "aws-registration.ons.009@ons.gov.uk"
	  name                         = "ons-cia-sandbox"
	  account_team                 = "cia"
	  account_env                  = "sandbox"
	  master_account_id            = aws_organizations_organization.org.master_account_id
	  splunk_user_arn              = aws_iam_user.splunk-user.arn
	  config_bucket                = aws_s3_bucket.ons-config.bucket
	  config_sns_topic_arn         = aws_sns_topic.ons-config-topic.arn
	  master_guardduty_detector_id = aws_guardduty_detector.ons-guardduty.id
	  s3_access_sqs_arn            = aws_sqs_queue.ons-s3-access-sqs.arn
	  master_zone_id               = aws_route53_zone.aws-onsdigital-uk.zone_id
	  dns_zone                     = "cia"
	}

In this example, the following elements are:

* `source` - refers to the location of the TF Module. In this scenario, the Module is being loaded from a local file
  source within the same repository, however the module could be called from the Registry, from git or from S3. It is
  important to note that any breaking changes to the module should consider introducing versioning/pinning, which would
  require the module being available via one of the methodologies that supports this.
* `email` - there exists a number of email addresses that have been created for use. The actual creation of these emails
  exists outside of this repo, the repo is here to only configure them. This email address will correspond to one of the
  email addresses associated to one of these Accounts. A full list of Accounts is below in this file and using a new one
  requires for the list to be updated. Access to these email addresses can be obtained via CloudOps
* `name` - this is the name that will be used for the Account
* `account_team` - this refers to the Team who will be responsible for this Account, e.g. `cia`, `catd`, etc
* `account_env` - this refers to what the intentional use in terms of deployed Environment is for the Account. Will be one
  of `sandbox`, `dev`, `int`, `uat`, `preprod`, `prod`. It is not currently clear if this list is complete or should be
  corresponding to a defined list somewhere, however its usage within the module is confined to it being used to set the `env`
  Tag on the `aws_organizations_account` Resource.
* `master_account_id` - expects to be passed a reference to the Master Account Id, which is defined within the `aws/main.tf`
  file in the root of the repo, and is an attribute of the `aws_organizations_organization.org` Resource
* `splunk_user_arn` - expects to be passed a reference to the `aws_iam_user.splunk-user` Resource, which is defined within
  the `aws/main.tf` file in the root of the repo. Used to define the IAM User that should be used for Splunk.
* `config_bucket` - expects to be passed a reference to the `aws_s3_bucket.ons-config` Resoruce, which is defined within the
  `aws/main.tf` file in the root of the repo. Used to define the S3 Bucket where Config Recoreder Logs should be sent. Used by
  `aws_config_delivery_channel.config-delivery-channel` as the `s3_bucket_name`
* `config_sns_topic_arn` - expects to be passed a reference to `aws_sns_topic.ons-config-topic`, which is defined within the
  `aws/main.tf` file in the root fo the repo. Used by `aws_config_delivery_channel.config-delivery-channel` as the
  `sns_topic_arn`
* `master_guardduty_detector_id` - expects to be passed in a reference to the Parent Account GuardDuty
  `aws_guardduty_detector.ons-guarduty`. Whilst this is being passed in, it does not appear to being utilised within the
  module as of this time
* `s3_access_sqs_arn` - expects to be passed a reference to the SQS Queue in the Parent Account that should be used to
  post on regarding S3 Access. There is a requirement to add additionally-created S3 buckets ARNs (as a module ref) to the
  `aws_sqs_queue_policy.ons-s3-access-sqs-policy` in-line Policy, under `aws:SourceArn`, otherwise S3 will not be able to
  post messages to the `aws_sqs_queue.ons-s3-access-sqs` SQS
* `master_zone_id` - expects a reference to the HZ ID defined for `aws.onsdigital.uk` defined in the root of the repo
* `dns_zone` - this value is used to define what the Account-specific Route 53 Hosted Zone sub-domain should look like,
  for example `cia` provides a Hosted Zone of `cia.aws.onsdigital.uk`

### Module Documentation
* `aws_organizations_account.account` - Takes the `var.name` and `var.email` from the Module configuration to create an
  AWS Account, tagging it with teh `var.account_team` and `var_account_env` values. Contains a `local-exec` to sleep for
  120 seconds as AWS Accounts take some time to become ready when created
* `provider.aws` - Is configured to expect an IAM Role within the Account that should be created by Organizations, named
  `OrganizationAccountAccessRole`, which is then Assumed. The new Account ID from the `account` resource is used
* `aws_iam_service_linked_role.config` - creates a SLR for the Config Recorder
* `aws_config_configuration_recorder.config-recorder` - uses the above SLR for Config Recorder configuration
* `aws_config_configuration_recorder_status.config-recorder-status` - This resource enables or disables the Config Recorder
  itself, and depends on the existence of the `aws_config_delivery_channel.config-delivery-channel`
* `aws_config_delivery_channel.config-delivery-channel` - The actual delivery channel for Config. Requires an S3 bucket
  in which to store configuration history, and an SNS topic to deliver Config notifications to
* `aws_s3_bucket.s3-access` - creates an S3 bucket resource named for the instantiation of the module, which allows access
  to a `var.splunk_user_arn`. It has a lifecycle rule set that expires objects after 60 days
* `aws_s3_bucket_public_access_block.s3-access` - is the Bucket Public Access Block configuration. This ensures that the
  bucket isn't set to public, or allowing public objects
* `aws_s3_bucket_notification.s3-access` - this manages the S3 Bucket notification config. It dictates that an SQS message
  be created for every object that is created in the S3 bucket, as it is recording events for `s3:ObjectCreated:*`
* `aws_route53_record.account-aws-onsdigital-uk-ns` - to support the usage of custom DNS records based on the Team Name,
  and being configured via the `var.dns_zone` option, this utilises the `var.master_zone_id` to create a Name Server
  type record in the Parent Account Hosted Zone.
* `aws_route53_zone` - creates a new Route 53 Hosted Zone, based on the `var.dns_zone` which is passed in, both to dictate
  if the resource should be deployed, and to provide the Name of the actual record. The creation of this Hosted Zone, which
  is configured in the `aws_route53_record.account-aws-onsdigital-uk-ns` to be a sub-domain within the `ons-digital.uk`
  domain, allows for Account-specific sub-domains to be created. Whilst this is mostly fine, it does create an expectation
  around the naming of AWS Accounts being strongly reflective of their usage - however since the created subdomains are
  based off the `var.dns_zone` being passed in, this is a string-only configuration of this item, so as long as there
  are no conflicts this should not present any issues
