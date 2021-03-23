# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

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
