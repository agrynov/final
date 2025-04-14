resource "aws_instance" "agrynov-instance-public" {
 ami = "ami-0ecf75a98fe8519d7"
 instance_type = "t2.micro"
 subnet_id = aws_subnet.agrynov-subnet-public.id
 vpc_security_group_ids = [aws_security_group.agrynov-sg.id]
 key_name = aws_key_pair.agrynov_key.key_name

 tags = {
    Name = "agrynov-public-instance-hw19"
    Owner = "agrynov"
  }
 } 

resource "aws_instance" "agrynov-instance-private" {
    ami = "ami-0ecf75a98fe8519d7"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.agrynov-subnet-private.id
    vpc_security_group_ids = [aws_security_group.agrynov-sg.id]
    #key_name = aws_key_pair.agrynov_key.key_name

 tags = {
    Name = "agrynov-private-instance-hw19"
    Owner = "agrynov"
  }
}

resource "aws_security_group" "agrynov-sg" {
    name = "agrynov-ssh"
    vpc_id = aws_vpc.agrynov-vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }    
  
  tags = {
    Owner = "agrynov"
  }
}

resource "aws_key_pair" "agrynov_key" {
    key_name = "agrynov_key"
    public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPPpz5fSBEv56vyejq5P1syaizYzFoNY7GFi1AUMMz3c andrijgrinov@MB-AIR-AG.local"

}