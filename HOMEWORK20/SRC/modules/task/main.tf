resource "aws_security_group" "agrynov_hw20_nginx_sg" {
  name   = "nginx-sg"
  vpc_id = var.vpc_id


  dynamic "ingress" {
    for_each = var.list_of_open_ports
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


resource "aws_instance" "agrynov_hw20_nginx_instance" {
  ami                    = "ami-0ecf75a98fe8519d7"
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.agrynov_hw20_nginx_sg.id]
  user_data              = <<-EDF
#!/bin/bash
sudo yum update -y
sudo yum install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
    EDF

}
