# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.178.0.0/20"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "my-custom-vpc"
  }
}

# Internet Gateway (IGW)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-vpc-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# NACL (Default-like)
resource "aws_network_acl" "default_like" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "default-like-nacl"
  }
}

resource "aws_network_acl_rule" "inbound_allow_all" {
  network_acl_id = aws_network_acl.default_like.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "outbound_allow_all" {
  network_acl_id = aws_network_acl.default_like.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# Subnets - AZ0 (eu-west-2a)
# Public (/24) in AZ0
resource "aws_subnet" "public_a1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.178.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.azs[0]

  tags = {
    Name = "public-subnet-a1"
  }
}

resource "aws_subnet" "public_a2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.178.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.azs[0]

  tags = {
    Name = "public-subnet-a2"
  }
}

# Private (/27) in AZ0
resource "aws_subnet" "private_a1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.178.2.0/27"
  map_public_ip_on_launch = false
  availability_zone       = var.azs[0]

  tags = {
    Name = "private-subnet-a1"
  }
}

resource "aws_subnet" "private_a2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.178.2.32/27"
  map_public_ip_on_launch = false
  availability_zone       = var.azs[0]

  tags = {
    Name = "private-subnet-a2"
  }
}

# Subnets - AZ1 (eu-west-2b)
# Public (/24) in AZ1
resource "aws_subnet" "public_b1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.178.10.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.azs[1]

  tags = {
    Name = "public-subnet-b1"
  }
}

resource "aws_subnet" "public_b2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.178.11.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.azs[1]

  tags = {
    Name = "public-subnet-b2"
  }
}

# Private (/27) in AZ1
resource "aws_subnet" "private_b1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.178.12.0/27"
  map_public_ip_on_launch = false
  availability_zone       = var.azs[1]

  tags = {
    Name = "private-subnet-b1"
  }
}

resource "aws_subnet" "private_b2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.178.12.32/27"
  map_public_ip_on_launch = false
  availability_zone       = var.azs[1]

  tags = {
    Name = "private-subnet-b2"
  }
}

# Route Table Associations
# Public Subnets to Public Route Table
resource "aws_route_table_association" "pub_assoc_a1" {
  subnet_id      = aws_subnet.public_a1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "pub_assoc_a2" {
  subnet_id      = aws_subnet.public_a2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "pub_assoc_b1" {
  subnet_id      = aws_subnet.public_b1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "pub_assoc_b2" {
  subnet_id      = aws_subnet.public_b2.id
  route_table_id = aws_route_table.public.id
}

# NACL Associations
# Associate custom NACL with all subnets
resource "aws_network_acl_association" "public_a1_nacl" {
  subnet_id      = aws_subnet.public_a1.id
  network_acl_id = aws_network_acl.default_like.id
}

resource "aws_network_acl_association" "public_a2_nacl" {
  subnet_id      = aws_subnet.public_a2.id
  network_acl_id = aws_network_acl.default_like.id
}

resource "aws_network_acl_association" "private_a1_nacl" {
  subnet_id      = aws_subnet.private_a1.id
  network_acl_id = aws_network_acl.default_like.id
}

resource "aws_network_acl_association" "private_a2_nacl" {
  subnet_id      = aws_subnet.private_a2.id
  network_acl_id = aws_network_acl.default_like.id
}

resource "aws_network_acl_association" "public_b1_nacl" {
  subnet_id      = aws_subnet.public_b1.id
  network_acl_id = aws_network_acl.default_like.id
}

resource "aws_network_acl_association" "public_b2_nacl" {
  subnet_id      = aws_subnet.public_b2.id
  network_acl_id = aws_network_acl.default_like.id
}

resource "aws_network_acl_association" "private_b1_nacl" {
  subnet_id      = aws_subnet.private_b1.id
  network_acl_id = aws_network_acl.default_like.id
}

resource "aws_network_acl_association" "private_b2_nacl" {
  subnet_id      = aws_subnet.private_b2.id
  network_acl_id = aws_network_acl.default_like.id
}