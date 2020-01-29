provider "aws" {
  region = "eu-west-1"
}

provider "mongodbatlas" {
  public_key  = "${var.mongodbatlas_public_key}"
  private_key = "${var.mongodbatlas_private_key}"
}

terraform {
  backend "s3" {
    bucket = "go-rest-api-terraform-state"
    key    = "go-rest-api/prod/fargate/terraform.tfstate"
    region = "eu-west-1"
  }
}
