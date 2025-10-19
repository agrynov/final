# AWS account config
region = "eu-central-1"
iam_profile = "default"  # або назва вашого AWS profile

# This is the name prefix for all infra components
name = "agrynov"

vpc_id       = "vpc-0d36300b8ac09e636"
subnets_ids  = ["subnet-00deff8c9cc2385a7", "subnet-045cf8f75e32da6ad", "subnet-0dc2a67f3896d5b0e"]

tags = {
  Environment = "test-agrynov"
  TfControl   = "true"
  owner       = "agrynov"
}

zone_name = "devops7.test-danit.com"
