#devopshint_VPC

resource "aws_vpc" "devopshint_vpc" {
  cidr_block       = "10.0.0.0/18"
#   instance_tenancy = "default"

  tags = {
    Name = "devopshint_VPC"
  }
}

#public subnet

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.devopshint_vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "public subnet"
  }
}

#Private subnet

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.devopshint_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "private subnet"
  }
}


#AWS internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.devopshint_vpc.id

  tags = {
    Name = "devopshint_vpc IGW"
  }
}


#public route table

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.devopshint_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public route table"
  }
}


#public route table assiciation

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}