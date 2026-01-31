#creating security group

resource "aws_security_group" "security_group" {
  description = "Allow limited inbound external traffic"
  vpc_id      = "${aws_vpc.devopshint_vpc.id}"
  name        = "terraform_ec2_private-sg"



ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
}

ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 8080
    to_port = 8080
}

ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 443
    to_port = 443
}

egress {
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
}
  tags = {
    Name = "ec2-private-sg"
  }
}

output "aws_security_gr_id" {
  value =  "${aws_security_group.security_group.id}"
}



#creating EC2 Instances in public subnet

resource "aws_instance" "ec2_instance" {
  ami           = "ami-0a03139288d18e3c4" # Deep Learning OSS Nvidia Driver 2.9 (Ubuntu 24.04)
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = ["${aws_security_group.security_group.id}"]
  key_name = "SSH login"
  count = 1
  associate_public_ip_address = true

  tags = {
    Name = "Public_Instance"
  }
}


#creating EC2 Instances in Private subnet

resource "aws_instance" "ec2_instance_private" {
  ami           = "ami-0a03139288d18e3c4" # Deep Learning OSS Nvidia Driver 2.9 (Ubuntu 24.04)
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_subnet.id
  security_groups = ["${aws_security_group.security_group.id}"]
  key_name = "SSH login"
  count = 1
  associate_public_ip_address = false

  tags = {
    Name = "Private_Instance"
  }
}


# resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
#   security_group_id = aws_security_group.allow_tls.id
#   cidr_ipv4         = aws_vpc.main.cidr_block
#   from_port         = 443
#   ip_protocol       = "tcp"
#   to_port           = 443
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
#   security_group_id = aws_security_group.allow_tls.id
#   cidr_ipv6         = aws_vpc.main.ipv6_cidr_block
#   from_port         = 443
#   ip_protocol       = "tcp"
#   to_port           = 443
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
#   security_group_id = aws_security_group.allow_tls.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
#   security_group_id = aws_security_group.allow_tls.id
#   cidr_ipv6         = "::/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }