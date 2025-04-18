variable "subnet_id"  {}
variable "allow_ports" {
  type = list(number)
}

variable "vpc_id" {}
variable "ssh_key_pair_name" {}
variable "instance_count" {
  default = 2
}