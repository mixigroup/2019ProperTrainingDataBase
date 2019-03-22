provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket  = "mixi-db-training"
    key     = "var/terraform/main.tfstate"
    region  = "us-west-2"
  }
}

data "aws_caller_identity" "self" { }
