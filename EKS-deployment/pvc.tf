#####VPC#########
resource "aws_pvc" "eks_vpc" {
  cidr_block = var.vpc_cidr
  tags={
    Name = "${var.cluster_name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_pvc.eks_vpc.vpc_id
  tags ={
    Name = "${var.cluster_name}-igw"
  }
}

##public subnets##

resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id = aws_pvc.eks_vpc.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags={
    Name = "${var.cluster_name}-public-${count.index + 1}"}
  }


#private subnets##
resource "aws_subnet" "private" {
  count = length(var.private_subnets)
  vpc_id = aws_pvc.eks_vpc.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.cluster_name}-private-${count.index + 1}"
  }
}

#public route table##
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "${var.cluster_name}-public-rt"
  }
}

resource "aws_route" "public_internet" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

##  Associate public subntes##
resource "aws_route_table_association" "public_assoc" {
  count = length(var.public_subnets)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


#security Group###
resource "aws_security_group" "eks_worker_sg" {
  name = "${var.cluster_name}-worker-sg"
  vpc_id = aws_pvc.eks_vpc.id
  description = "EKS worker nodes SG"

  ingress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_block = ["0.0.0.0/0"]
  }

egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

}

