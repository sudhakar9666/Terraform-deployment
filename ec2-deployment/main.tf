##VPC networking###
resource "aws_vpc" "myvpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.Project_name}-vpc"
  }
}

resource "aws_subnet" "my-subnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.Project_name}-public-subnet"
  }
}

resource "aws_subnet" "my-subnet-2" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.Project_name}-private-subnet"
  }
}

resource "aws_internet_gateway" "my_gateway" {
  vpc_id = aws_vpc.myvpc.id
  tags   = {
 Name= "${var.Project_name}-my-igw"
  }

}
##creating route table##
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gateway.id
  }

  tags = {
    Name = "public-route-table"
  }
}



#associating route table##
resource "aws_route_table_association" "public-assos" {
  subnet_id = aws_subnet.my-subnet.id
  route_table_id = aws_route_table.public.id
}

##security##
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow-ssh-http"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh-http"
  }
}
