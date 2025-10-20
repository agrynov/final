region      = "eu-central-1"
iam_profile = "agrynov"
name        = "agrynov"

vpc_id = "vpc-08c6253a8cd6c0329"
subnets_ids = [
  "subnet-03b4daebc1f53f2b3",
  "subnet-0a18eaebb400ca30b"
]

cluster_name = "agrynov"
eks_version  = "1.29"

node_group_name     = "agrynov"
node_instance_types = ["t3.medium"]
node_desired_size   = 1
node_min_size       = 1
node_max_size       = 2

coredns_version        = "v1.12.2-eksbuild.4"
ingress_nginx_version  = "4.10.0"
metrics_server_version = "3.12.1"

zone_name = "devops7.test-danit.com"

tags = {
  Environment = "test-agrynov"
  TfControl   = "true"
  owner       = "agrynov"
  Project     = "step-final"
  ManagedBy   = "terraform"
}
