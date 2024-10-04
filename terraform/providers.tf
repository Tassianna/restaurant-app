terraform {
  backend "s3" {
    bucket         = "terraform-state-tassi-grace-london"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "statedb"
  }
}
provider "aws" {
  region = "eu-west-2"
}