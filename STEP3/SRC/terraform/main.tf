terraform {
  backend "s3" {
    bucket = "sp-agrynov-jenkins-tf-state"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "compute" {
  source = "./compute"

  ami_id              = var.ami_id
  key_name            = var.key_name
  public_key_path     = var.public_key_path
  instance_type_master = var.instance_type_master
  instance_type_worker = var.instance_type_worker
}
