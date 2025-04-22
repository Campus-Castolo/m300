# ✅ M300 VPC Setup with Referenced VPC Flow Logs (from infrastructure-sec.tf)

resource "aws_vpc" "m300_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "M300-VPC"
  }
}

# VPC Flow Log Resource (no duplicates, uses existing resources from infrastructure-sec.tf)
resource "aws_flow_log" "vpc_logs" {
  vpc_id               = aws_vpc.m300_vpc.id
  traffic_type         = "ALL"
  log_destination_type = "cloud-watch-logs"
  log_group_name       = aws_cloudwatch_log_group.vpc_flow_logs.name
  iam_role_arn         = aws_iam_role.vpc_flow_logs.arn
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.m300_vpc.id
  tags = {
    Name = "M300-IGW"
  }
}

# Public Subnets
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.m300_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "M300-Public-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.m300_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "M300-Public-2"
  }
}

# Private Subnets
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.m300_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-central-1a"
  tags = {
    Name = "M300-Private-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.m300_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-central-1b"
  tags = {
    Name = "M300-Private-2"
  }
}

# Public Route Table & Associations
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.m300_vpc.id
  tags = {
    Name = "M300-Public-RT"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_1_assoc" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2_assoc" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Table & Associations
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.m300_vpc.id
  tags = {
    Name = "M300-Private-RT"
  }
}

resource "aws_route_table_association" "private_1_assoc" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_2_assoc" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt.id
}
