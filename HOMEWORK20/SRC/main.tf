data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


module "agrynov-hw20" {
  source             = "./modules/task"
  project_name       = var.project_namehw20
  list_of_open_ports = var.list_of_open_ports
  subnet_id          = data.aws_subnets.default_vpc_subnets.ids[0]
  vpc_id             = data.aws_vpc.default.id

}
