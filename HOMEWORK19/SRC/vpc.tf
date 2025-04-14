provider "aws" {
  region = "eu-central-1"
  #profile = "mfa"  
}

terraform {
  backend "s3" {
    bucket = "agrynov-hw19"
    key = "terraform.tfstate"
    region = "eu-central-1"
   # profile = "mfa"
  }
}

resource "aws_vpc" "agrynov-vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "agrynov-vpc-hw19"
    Owner = "agrynov"
  }
}

resource "aws_subnet" "agrynov-subnet-public" {
  vpc_id = aws_vpc.agrynov-vpc.id
  cidr_block = "10.0.15.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "agrynov-public-hw19"
    Owner = "agrynov"
  }
}

resource "aws_subnet" "agrynov-subnet-private" {
  vpc_id = aws_vpc.agrynov-vpc.id
  cidr_block = "10.0.20.0/24"

  tags = {
    Name = "agrynov-private-hw19"
    Owner = "agrynov"
  }
}

resource "aws_eip" "agrynov-eid" {
  domain = "vpc"  

  tags = {
    Name = "agrynov-eip-hw19"
    Owner = "agrynov"
  }
}

resource "aws_internet_gateway" "agrynov-gw" {
  vpc_id = aws_vpc.agrynov-vpc.id
  
  tags = {
    Name = "agrynov-igw-hw19"
    Owner = "agrynov"
  }
}

resource "aws_nat_gateway" "agrynov-nat-gw" {
  allocation_id = aws_eip.agrynov-eid.id
  subnet_id = aws_subnet.agrynov-subnet-public.id

    tags = {
    Name = "agrynov-nat-gw-hw19"
    Owner = "agrynov"
  }
}

resource "aws_route_table" "agrynov-rt-public" {
  vpc_id = aws_vpc.agrynov-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.agrynov-gw.id
  }

  tags = {
    Name = "agrynov-rt-public-hw19"
    Owner = "agrynov"
  }
}

resource "aws_route_table_association" "agrynov-rt-association-public" {
  subnet_id = aws_subnet.agrynov-subnet-public.id
  route_table_id = aws_route_table.agrynov-rt-public.id
}


resource "aws_route_table" "agrynov-rt-privaate" {
  vpc_id = aws_vpc.agrynov-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.agrynov-nat-gw.id
  }

  tags = {
    Name = "agrynov-rt-private-hw19"
    Owner = "agrynov"
  }
}

resource "aws_route_table_association" "agrynov-rt-association-private" {
  subnet_id = aws_subnet.agrynov-subnet-private.id
  route_table_id = aws_route_table.agrynov-rt-privaate.id
  
}

