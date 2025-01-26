# VPC for Testudo
resource "aws_vpc" "testudo_vpc" {
  cidr_block = "172.16.0.0/22"

  tags = {
    Name = "testudo_vpc"
  }
}

# Subnet for redirectors
resource "aws_subnet" "redirectors_subnet" {
  vpc_id                  = aws_vpc.testudo_vpc.id
  cidr_block              = "172.16.1.0/24"
  map_public_ip_on_launch = false
  availability_zone       = var.AWS_AVAIL_ZONE

  tags = {
    Name = "redirectors_subnet"
  }
}

# Subnet for C2 and Phishing servers to reside in
resource "aws_subnet" "c2_subnet" {
  vpc_id                  = aws_vpc.testudo_vpc.id
  cidr_block              = "172.16.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = var.AWS_AVAIL_ZONE

  tags = {
    Name = "c2_subnet"
  }
}

# Subnet for Operator/jumpbox
resource "aws_subnet" "operators_subnet" {
  vpc_id                  = aws_vpc.testudo_vpc.id
  cidr_block              = "172.16.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.AWS_AVAIL_ZONE

  tags = {
    Name = "operators_subnet"
  }
}

resource "aws_internet_gateway" "igw_public" {
  vpc_id = aws_vpc.testudo_vpc.id

  tags = {
    Name = "igw_testudo"
  }
}

resource "aws_route_table" "rt_testudo" {
  vpc_id = aws_vpc.testudo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_public.id
  }

  route {
    cidr_block = "172.16.0.0/22"
    gateway_id = "local"
  }

  tags = {
    Name = "rt_testudo"
  }
}

resource aws_main_route_table_association "testudo_main_rt" {
  vpc_id = aws_vpc.testudo_vpc.id
  route_table_id = aws_route_table.rt_testudo.id
}

resource "aws_route_table_association" "rta_redirectors" {
  subnet_id      = aws_subnet.redirectors_subnet.id
  route_table_id = aws_route_table.rt_testudo.id
}

resource "aws_route_table_association" "rta_c2_servers" {
  subnet_id      = aws_subnet.c2_subnet.id
  route_table_id = aws_route_table.rt_testudo.id
}

resource "aws_route_table_association" "rta_jumpboxes" {
  subnet_id      = aws_subnet.operators_subnet.id
  route_table_id = aws_route_table.rt_testudo.id
}