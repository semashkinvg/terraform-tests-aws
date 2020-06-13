provider "aws" {
  version = "~> 2.55.0"
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "test-aws-itwas-me"
    key = "aws.tfstate"
    region = "eu-west-1"
    dynamodb_table = "test-aws-terraform-lock"
  }
}