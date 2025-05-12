variable "ami_id" {
  description = "AMI ID Amazon Linux"
  type        = string
}

variable "key_name" {
  description = "SSH key name"
  type        = string
}

variable "public_key_path" {
  description = "SSh payh"
  type        = string
}

variable "instance_type_master" {
  description = "EC2 Jenkins Master"
  type        = string
}

variable "instance_type_worker" {
  description = "EC2 Jenkins Worker"
  type        = string
}
