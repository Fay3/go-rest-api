provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "stevenquan-terraform"
    key    = "go-rest-api/initial/terraform.tfstate"
    region = "eu-west-1"
  }

  required_version = "0.12.13"
}
