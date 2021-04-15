# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.2.4] - 2021-04-15
## IAM Configuration - [Jira Ticket](https://collaborate2.ons.gov.uk/jira/browse/IDPT-451)
 - Modified **restricted-admin** resource names from `restricted-admin` to `administrator`
- Modified **restricted-admin-read-only** resource names from `restricted-admin-read-only` to `administrator-read-only`
- Modified **developer-dev** resource names from `developer-dev` to `developer`
- Refactored terraform references and ran tests to verify
- Updated the documentation with testing section


## [0.2.3] - 2021-04-13
## Provision ACM Certs - [Jira Ticket](https://collaborate2.ons.gov.uk/jira/browse/IDPT-446)
- Modified zone name suffix from `aws.onsdigital.uk` to `idp.onsdigital.uk`


## [0.2.2] - 2021-04-06
## Deploy AWS-D Part 2 - [Jira Ticket](https://collaborate2.ons.gov.uk/jira/browse/IDPT-442)
- Remove Splunk logging configuration/resources in favour of the **Events** module implementation
- Add Terraform state management resources as part of account provisioning
- Refactor AWS-Config recording to record within member account
- Added provider config for provisioning member account
- Removed **zone delegation** record resource in favour of implementing outside module


## [0.2.1] - 2021-03-29
## Add CI Role and Break Glass User - [Jira Ticket](https://collaborate2.ons.gov.uk/jira/browse/IDPT-354)
- Created CI/CD IAM policy and Role to be deployed to all aws accounts
  - Best guess at IAM policy for resources that we're likely to manage with ci running on ec2
- Created an administrative user to be deployed to all aws accounts
  - `breakglass` user will have the same privileges as `restricted-admin` role in development accounts
- Added additional permissions to `restricted-admin` policy
  - **restricted-admin**: `autoscaling:*`, `iam:*`, `vpc:*` and `cloudfront:*`
- Fixed: `restricted-admin` policy empty resources arg
- Added additional logic to differentiate an `iam` type AWS account
  - Like non `dev` AWS accounts, `iam` AWS accounts exclude `restricted-admin` roles etc..
  - `iam` AWS accounts also exclude route53 resources
- Added/Refactored unit tests


## [0.2.0] - 2021-03-26
## Refactor Module - [Jira Ticket](https://collaborate2.ons.gov.uk/jira/browse/IDPT-355)
- removed provider blocks.  Should be implemented outside of module
  - one was to configure region
  - the other was used to associate the created account with an organisation
- split resources into different terraform files depending on type
- modified resource names
- added the roles and policies for restricted-admin, restricted-admin-read-only, developer, developer-read-only and end-user
- added contract tests to variables
- added unit tests for dev AWS account role, policy logic
- added unit tests for s3 splunk logs logic
- pinned versions to terraform 14 and aws provider ~> 3
- amended readme to reflect changes
- added steps to github actions yaml


## [0.1.0] - 2021-03-22
## Initial Commit - [Jira Ticket](https://collaborate2.ons.gov.uk/jira/browse/IDPT-351)
- Ported `Account` terraform module from [here](https://github.com/ONSdigital/aws-terraform/tree/main/terraform/aws/Account) 
  to this repo
- Added **TODO**s to address recommended changes for future versions of this module which would be incompatible with AWS-B
  invocations
- Added pr **action** to check formatting
