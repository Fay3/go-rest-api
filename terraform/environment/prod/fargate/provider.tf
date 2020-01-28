provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "go-rest-api-terraform-state"
    key    = "go-rest-api/prod/fargate/terraform.tfstate"
    region = "eu-west-1"
  }
}
