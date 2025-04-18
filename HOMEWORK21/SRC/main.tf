provider "aws" {
    #profile = "mfa"
    region = "eu-central-1"
  
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "ec2" {
  source = "./compute"
  vpc_id = data.aws_vpc.default.id
  subnet_id = data.aws_subnets.default_vpc_subnets.ids[0]
  allow_ports = var.allow_ports
  ssh_key_pair_name = var.ssh_key_pair_name
  instance_count = 2
}

resource "local_file" "name" {
  content = module.ec2.ssh_key_pair_name
  filename = "${path.module}/privatehw21.key"
  file_permission = "0400"
  }

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    instance_ips = module.ec2.instance_public_ips
  })

    filename = "${path.module}/ansible/inventory"
  }