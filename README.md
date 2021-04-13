# terraform-module-aws-account
Provision AWS accounts within an organisation 

## Requirements

| Name | Version |
|------|---------|
| [Terraform](https://www.terraform.io/downloads.html) | >= 0.12.0, < 0.15.0 |


## Providers

| Name | Version |
|------|---------|
| aws |  >= 3.33.0, < 4.0.0 |


## Account Module
Usage of the `Account` module within this repository is delimited by way of groups/team within the ONS, within files
named for the group/team.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_env | The intentional use of the account. i.e. dev, staging, production | `string` | n/a | yes |
| account\_team | The Team who will be responsible for this Account, e.g. cia, catd, etc.. | `string` | n/a | yes |
| dns\_subdomain | The subdomain to create in this account and then delegate control to domain: `aws.onsdigital.uk.` i.e. dns_subdomain = example.  Yields: example.aws.onsdigital.uk | `string` | `""` | no |
| iam_account_id | The Id of the AWS account where user's IAM user accounts reside | `string` | n/a | yes |
| logging\_bucket | The name of the logging bucket to export account level s3 logs | `string` | `""` | no |
| master\_zone\_id | The optional zone Id of the ONS parent domain aws.onsdigital.uk to which control of this account's domain will be delegated | `string` | `""` | no |
| name | The alias of the AWS account.  Also used as the common name for resources created as part of this module | `string` | n/a | yes |
| root\_account\_email | The email address to associate with the root account.  Refer to this [table](https://github.com/ONSdigital/aws-terraform/blob/main/README.md#aws-accounts-list) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| account\_id | The Id of the newly created member AWS account |
| account\_root\_email | The email address of the root account |
| state\_bucket | The name of the state bucket |
| zone\_id | The zone Id of the AWS account's route53 zone |
| zone\_name | The name of the AWS account's route53 zone |
| zone\_name\_servers | The name servers of the AWS account's route53 zone |


### Module Usage

To promote best practices such as CI/CD and least privileged, only AWS accounts provisioned for **development** purposes will 
contain roles (`restricted-admin`, `developer`) that allow users to interactively create, edit and destroy resources.

To provision an AWS account for development purposes, pass the value `dev` to the `account_env` argument. For an account 
to manage users pass the value `iam` to the `account_env` argument.


#### Provider Configuration

Organisation member accounts have a special admin role named `OrganizationAccountAccessRole`.  See: [Member Account Admin](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html)

Once the organisation member account has been created, Terraform should provision all other resources defined in this module by 
assuming `OrganizationAccountAccessRole` within the newly created member account.

```terraform
provider "aws" {
  alias                       = "account"
  region                      = "eu-west-2"
}

provider "aws" {
  alias                       = "dev"
  region                      = "eu-west-2"
  
  assume_role {
    role_arn = "arn:aws:iam::${module.dev.account_id}:role/OrganizationAccountAccessRole"
  }
}
```


Provision an aws account for development purposes

**Note**
Contains administrative roles `restricted-admin` and `developer`

```terraform
module "dev" {
  source  = "ONSdigital/account/aws"
  version = "~> 0.2.2"

  account_env          = "dev"
  account_team         = "cia"
  root_account_email   = "aws-registration.ons.000@ons.gov.uk"
  name                 = "dev"
  dns_subdomain        = "dev"
  master_zone_id       = "M4ST3RZ0N3ID"
  iam_account_id       = module.iam.account_id

  providers = {
    aws         = aws.dev
    aws.account = aws.account
  }
}
```

Provision an AWS account for testing, production etc...

```terraform
module "prod" {
  source  = "ONSdigital/account/aws"
  version = "~> 0.2.2"

  account_env        = "prod"
  account_team       = "catd"
  root_account_email = "aws-registration.ons.000@ons.gov.uk"
  name               = "prod"
  dns_subdomain      = "prod"
  master_zone_id     = "M4ST3RZ0N3ID"
  iam_account_id     = module.iam.account_id
  logging_bucket     = aws_s3_bucket.logging_bucket.id

  providers = {
    aws         = aws.prod
    aws.account = aws.account
  }
}
```

Provision an AWS account for managing identity i.e. `iam`

```terraform
module "iam" {
  source  = "ONSdigital/account/aws"
  version = "~> 0.2.2"

  account_env        = "iam"
  account_team       = "cia"
  root_account_email = "aws-registration.ons.000@ons.gov.uk"
  name               = "iam"
  dns_subdomain      = "iam"
  master_zone_id     = "M4ST3RZ0N3ID"
  iam_account_id     = module.iam.account_id
  logging_bucket     = aws_s3_bucket.logging_bucket.id

  providers = {
    aws         = aws.iam
    aws.account = aws.account
  }
}
```
