provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "sp_ag_backend" {
  bucket = "sp-agrynov-jenkins-tf-state"

  tags = {
    Name        = "sp-ag-backend-s3"
    Owner       = "sp3agrynov"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "sp_ag_backend_versioning" {
  bucket = aws_s3_bucket.sp_ag_backend.id

  versioning_configuration {
    status = "Enabled"
  }
}
