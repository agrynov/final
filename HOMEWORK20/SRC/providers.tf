terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.94.1"
    }
  }
  backend "s3" {
    bucket = "agrynov-hw20"
    key = "terraform.tfstate"
    region = "eu-central-1"
    #profile = "mfa"
}
}
provider "aws" {
  region = "eu-central-1"
}