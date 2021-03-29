terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.33.0, < 4.0.0"
    }
  }
  required_version = ">= 0.12.0, < 0.15.0"
}
