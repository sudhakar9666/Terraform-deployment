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

# Generate SSH key + AWS Key Pair
##############################
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.Project_name}-ec2-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

##############################
# Upload PEM to S3 (depends on bucket)
##############################
resource "aws_s3_bucket_object" "ec2_pem" {
  bucket                 = aws_s3_bucket.my-bucket.id
  key                    = "keys/${var.Project_name}-ec2-key.pem"
  content                = tls_private_key.ec2_key.private_key_pem
  server_side_encryption = "AES256"

  depends_on = [aws_s3_bucket.my-bucket]
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
###IAM Role + Policy + Instance Profile##

resource "aws_iam_role" "ec2_role" {
  name = "${var.Project_name}-ec2-role1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_policy" {
  name        = "${var.Project_name}-policy11"
  description = "Policy for EC2 to access S3 and Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "secretsmanager:GetSecretValue"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "role_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.Project_name}-instance-profile1"
  role = aws_iam_role.ec2_role.name
}

##s3 bucket#
resource "aws_s3_bucket" "my-bucket" {
  bucket = var.s3_bucket_name
  force_destroy = true

  tags = {
    Name = "${var.Project_name}-bucket"
  }
}
