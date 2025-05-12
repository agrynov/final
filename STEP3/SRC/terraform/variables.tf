variable "ami_id" {
  description = "AMI ID для Amazon Linux в регіоні eu-central-1"
  type        = string
}

variable "key_name" {
  description = "Ім'я SSH-ключа в AWS"
  type        = string
}

variable "public_key_path" {
  description = "Шлях до локального публічного SSH-ключа"
  type        = string
}

variable "instance_type_master" {
  description = "Тип EC2 інстансу для Jenkins Master"
  default     = "t2.micro"
}

variable "instance_type_worker" {
  description = "Тип EC2 інстансу для Jenkins Worker (spot)"
  default     = "t2.micro"
}
