resource "aws_vpc" "vpc_main" {
  cidr_block = var.cidr_block_vpc
  enable_dns_hostnames = true
  tags = {
    "Name" = "main-vpc"
  }
}

resource "aws_internet_gateway" "aws_igw" {
  vpc_id = aws_vpc.vpc_main.id
}

resource "aws_subnet" "public_subnet" {
  for_each = toset(var.public_subnets_cidrs)
  vpc_id = aws_vpc.vpc_main
  cidr_block = each.value
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public-subnet-${each.value}"
  }
}

resource "aws_subnet" "private_subnet" {
  for_each = toset(var.private_subnets_cidrs)
  vpc_id = aws_vpc.vpc_main
  cidr_block = each.value
  tags = {
    "Name" = "private-subnet-${each.value}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_main
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_igw.id
  }
}

resource "aws_route_table_association" "public_rt_associate" {
  for_each = aws_subnet.public_subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "sg_rds" {
  name        = var.sg_rds
  description = "Allow database access"
  vpc_id      = aws_vpc.vpc_main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_ecs" {
  name        = var.sg_ecs
  description = "Allow access for ECS tasks"
  vpc_id      = aws_vpc.vpc_main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_alb" {
  name        = "${var.environment}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.vpc_main.id

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
    Name        = "${var.environment}-alb-sg"
    Environment = var.environment
  }
}

