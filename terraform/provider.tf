terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.40.0"
    }
  }

  backend "s3" {
    bucket = "engie-access-africa-sre-challenge"
    key    = "terraform_state"
    region = "us-west-2"
    encrypt = true
  }
}
provider "aws" {
    region = "us-west-2"
}
