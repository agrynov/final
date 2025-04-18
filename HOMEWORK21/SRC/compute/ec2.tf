resource "tls_private_key" "ssh-agrynov" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh-key-agrynov" {
  key_name   = var.ssh_key_pair_name
  public_key = tls_private_key.ssh-agrynov.public_key_openssh
}

resource "aws_security_group" "ec2-agrynov-hw21-sg" {
  name   = "$(var.ssh_key_pair_name)-sg"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "hw21-agrynov" {
  count         = var.instance_count
  ami           = "ami-0ecf75a98fe8519d7"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.ssh-key-agrynov.key_name

  vpc_security_group_ids = [aws_security_group.ec2-agrynov-hw21-sg.id]

    tags = {
    Name = "hw21-instance-${count.index}"
    Owner = "agrynovhw21"
  }
}
