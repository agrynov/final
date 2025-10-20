terraform {
  backend "s3" {
    bucket         = "agrynov-tfstate"
    key            = "eks/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    profile        = "agrynov"
  }
}
