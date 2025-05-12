resource "aws_vpc" "sp-ag-main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "sp-ag-vpc"
    Owner       = "sp3agrynov"
     
  }
}

resource "aws_subnet" "sp-ag-public" {
  vpc_id                  = aws_vpc.sp-ag-main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "sp-ag-public-subnet"
    Owner       = "sp3agrynov"

  }
}

resource "aws_subnet" "sp-ag-private" {
  vpc_id                  = aws_vpc.sp-ag-main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = false

  tags = {
    Name        = "sp-ag-private-subnet"
    Owner       = "sp3agrynov"

  }
}

resource "aws_internet_gateway" "sp-ag-igw" {
  vpc_id = aws_vpc.sp-ag-main.id

  tags = {
    Name        = "sp-ag-igw"
    Owner       = "sp3agrynov"

  }
}

resource "aws_eip" "sp-ag-nat" {
  tags = {
    Name        = "sp-ag-nat-eip"
    Owner       = "sp3agrynov"

  }
}

resource "aws_nat_gateway" "sp-ag-nat" {
  allocation_id = aws_eip.sp-ag-nat.id
  subnet_id     = aws_subnet.sp-ag-public.id

  tags = {
    Name        = "sp-ag-nat-gateway"
    Owner       = "sp3agrynov"

  }

  depends_on = [aws_internet_gateway.sp-ag-igw]
}

resource "aws_route_table" "sp-ag-public-rt" {
  vpc_id = aws_vpc.sp-ag-main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sp-ag-igw.id
  }

  tags = {
    Name        = "sp-ag-public-rt"
    Owner       = "sp3agrynov"

  }
}

resource "aws_route_table_association" "sp-ag-public" {
  subnet_id      = aws_subnet.sp-ag-public.id
  route_table_id = aws_route_table.sp-ag-public-rt.id
}

resource "aws_route_table" "sp-ag-private-rt" {
  vpc_id = aws_vpc.sp-ag-main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.sp-ag-nat.id
  }

  tags = {
    Name        = "sp-ag-private-rt"
    Owner       = "sp3agrynov"

  }
}

resource "aws_route_table_association" "sp-ag-private" {
  subnet_id      = aws_subnet.sp-ag-private.id
  route_table_id = aws_route_table.sp-ag-private-rt.id
}

resource "aws_key_pair" "sp-ag-jenkins-key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "sp-ag-jenkins-sg" {
  name        = "sp-ag-jenkins-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.sp-ag-main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sp-ag-jenkins-sg"
    Owner       = "sp3agrynov"

  }
}

resource "aws_instance" "sp-ag-jenkins-master" {
  ami                         = var.ami_id
  instance_type               = var.instance_type_master
  subnet_id                   = aws_subnet.sp-ag-public.id
  key_name                    = aws_key_pair.sp-ag-jenkins-key.key_name
  vpc_security_group_ids      = [aws_security_group.sp-ag-jenkins-sg.id]
  associate_public_ip_address = true
  user_data                   = file("${path.module}/userdata-master.sh")

  tags = {
    Name        = "sp-ag-jenkins-master"
    Owner       = "sp3agrynov"

  }
}

resource "aws_instance" "sp-ag-jenkins-worker" {
  ami                         = var.ami_id
  instance_type               = var.instance_type_worker
  subnet_id                   = aws_subnet.sp-ag-private.id
  key_name                    = aws_key_pair.sp-ag-jenkins-key.key_name
  vpc_security_group_ids      = [aws_security_group.sp-ag-jenkins-sg.id]
  associate_public_ip_address = false
  user_data                   = file("${path.module}/userdata-worker.sh")

  tags = {
    Name        = "sp-ag-jenkins-worker"
    Owner       = "sp3agrynov"

  }
}
