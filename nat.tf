# AWS eip


resource "aws_eip" "nat_eip" {
  depends_on = [ aws_internet_gateway.igw]
  tags = {
    Name = "NAT Gateway EIP"
  }
}


# NAT gateway

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "devopshint_vpc NAT Gateway"
  }
}

# AWS route table

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.devopshint_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private route table"
  }
}

# AWS route table association

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
  
