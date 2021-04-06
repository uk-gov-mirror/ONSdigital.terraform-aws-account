provider "aws" {
  region                      = "eu-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_force_path_style         = true
  access_key                  = "access_key"
  secret_key                  = "secret_key"
}

provider "aws" {
  alias                       = "account"
  region                      = "eu-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_force_path_style         = true
  access_key                  = "access_key"
  secret_key                  = "secret_key"
}

provider "aws" {
  alias                       = "dev"
  region                      = "eu-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_force_path_style         = true
  access_key                  = "access_key"
  secret_key                  = "secret_key"

  assume_role {
    role_arn = "arn:aws:iam::${module.dev.account_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias                       = "testing"
  region                      = "eu-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_force_path_style         = true
  access_key                  = "access_key"
  secret_key                  = "secret_key"

  assume_role {
    role_arn = "arn:aws:iam::${module.test.account_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias                       = "iam"
  region                      = "eu-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_force_path_style         = true
  access_key                  = "access_key"
  secret_key                  = "secret_key"

  assume_role {
    role_arn = "arn:aws:iam::${module.iam.account_id}:role/OrganizationAccountAccessRole"
  }
}


module "dev" {
  source = "../"

  account_env        = "dev"
  account_team       = "cia"
  root_account_email = "aws.d.registration.000@ons.gov.uk"
  name               = "dev"
  dns_subdomain      = "dev"
  master_zone_id     = "M4ST3RZ0N3ID"
  iam_account_id     = module.iam.account_id

  providers = {
    aws         = aws.dev
    aws.account = aws.account
  }
}

module "test" {
  source = "../"

  account_env        = "test"
  account_team       = "catd"
  root_account_email = "aws.d.registration.000@ons.gov.uk"
  name               = "test"
  dns_subdomain      = "test"
  master_zone_id     = "M4ST3RZ0N3ID"
  iam_account_id     = module.iam.account_id

  providers = {
    aws         = aws.testing
    aws.account = aws.account
  }
}

module "iam" {
  source = "../"

  account_env        = "iam"
  account_team       = "cia"
  root_account_email = "aws.d.registration.000@ons.gov.uk"
  name               = "iam"
  dns_subdomain      = "iam"
  master_zone_id     = "M4ST3RZ0N3ID"
  iam_account_id     = module.iam.account_id
  logging_bucket     = aws_s3_bucket.test_logging_bucket.id

  providers = {
    aws         = aws.iam
    aws.account = aws.account
  }
}

resource "aws_s3_bucket" "test_logging_bucket" {
  bucket = "test-logging-bucket"
}
