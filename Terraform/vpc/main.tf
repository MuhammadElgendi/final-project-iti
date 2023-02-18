# VPC
resource "aws_vpc" "environment" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true 
  enable_dns_support   = true

  tags = {
    Name = var.environment
  }
}
############################################################################
# PUBLIC SUBNET 
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.environment.id
  cidr_block              = var.public_subnets
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = "us-east-1a"
  tags = {
    Name = "${var.environment}-public"
  }

}
resource "aws_internet_gateway" "environment" {
  vpc_id = aws_vpc.environment.id

  tags = {
    Name = "${var.environment}-igw"
  }
  depends_on = [aws_vpc.environment]
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.environment.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.environment.id
  }

  tags = {
    Name = "${var.environment}-public"
  }
}
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.environment.id
}
resource "aws_route_table_association" "public" {
  # count          = 1
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
############################################################################
# PRIVATE SUBNET
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.environment.id
  cidr_block              = var.private_subnets
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "${var.environment}-private"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.environment.id

  tags = {
    Name = "${var.environment}-private"
  }
}
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.environment.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_eip" "environment" {
  vpc = true
}

resource "aws_nat_gateway" "environment" {
  allocation_id = aws_eip.environment.id
  subnet_id     = aws_subnet.public.id
}
############################################################################
resource "aws_subnet" "private02" {
  vpc_id                  = aws_vpc.environment.id
  cidr_block              = var.private02_subnets
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1b"
  tags = {
    Name = "${var.environment}-private02"
  }

}
resource "aws_route_table" "private02" {
  vpc_id = aws_vpc.environment.id

  tags = {
    Name = "${var.environment}-private02"
  }
}
resource "aws_route" "private_nat_gateway02" {
  route_table_id         = aws_route_table.private02.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.environment02.id
}

resource "aws_route_table_association" "private02" {
  subnet_id      = aws_subnet.private02.id
  route_table_id = aws_route_table.private02.id
}

#################
resource "aws_eip" "environment02" {
  vpc = true
}

resource "aws_nat_gateway" "environment02" {
  allocation_id = aws_eip.environment02.id
  subnet_id     = aws_subnet.public.id
}
############################################################################
# SECUIRTY GROUP
resource "aws_security_group" "SG" {
  vpc_id = aws_vpc.environment.id
    ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

# We will use port 8000 to run k8s deployment for python app
  ingress {
    from_port = 8000
    to_port   = 8000 
    protocol  = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  egress  {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

