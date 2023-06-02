#Create AWS VPC
resource "aws_vpc" "wwealbvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags = {
    Name = "wwealbvpc"
  }
}

# Public Subnets in Custom VPC
resource "aws_subnet" "wwealbvpc-public-1" {
  vpc_id                  = aws_vpc.wwealbvpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-2a"

  tags = {
    Name = "wwealbvpc-public-1"
  }
}

resource "aws_subnet" "wwealbvpc-public-2" {
  vpc_id                  = aws_vpc.wwealbvpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-2b"

  tags = {
    Name = "wwealbvpc-public-2"
  }
}

resource "aws_subnet" "wwealbvpc-public-3" {
  vpc_id                  = aws_vpc.wwealbvpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-2c"

  tags = {
    Name = "wwealbvpc-public-3"
  }
}

# Private Subnets in Custom VPC
resource "aws_subnet" "wwealbvpc-private-1" {
  vpc_id                  = aws_vpc.wwealbvpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-south-2a"

  tags = {
    Name = "wwealbvpc-private-1"
  }
}

resource "aws_subnet" "wwealbvpc-private-2" {
  vpc_id                  = aws_vpc.wwealbvpc.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-south-2b"

  tags = {
    Name = "wwealbvpc-private-2"
  }
}

resource "aws_subnet" "wwealbvpc-private-3" {
  vpc_id                  = aws_vpc.wwealbvpc.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-south-2c"

  tags = {
    Name = "wwealbvpc-private-3"
  }
}

# Custom internet Gateway
resource "aws_internet_gateway" "wwealb-gw" {
  vpc_id = aws_vpc.wwealbvpc.id

  tags = {
    Name = "wwealb-gw"
  }
}

#Routing Table for the Custom VPC
resource "aws_route_table" "wwealb-public" {
  vpc_id = aws_vpc.wwealbvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wwealb-gw.id
  }

  tags = {
    Name = "wwealb-public-1"
  }
}

resource "aws_route_table_association" "wwealb-public-1-a" {
  subnet_id      = aws_subnet.wwealbvpc-public-1.id
  route_table_id = aws_route_table.wwealb-public.id
}

resource "aws_route_table_association" "wwealb-public-2-a" {
  subnet_id      = aws_subnet.wwealbvpc-public-2.id
  route_table_id = aws_route_table.wwealb-public.id
}

resource "aws_route_table_association" "wwealb-public-3-a" {
  subnet_id      = aws_subnet.wwealbvpc-public-3.id
  route_table_id = aws_route_table.wwealb-public.id
}
