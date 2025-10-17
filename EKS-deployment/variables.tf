variable "aws_region" {
  description = "AWS region"
  type = string
  default = "us-east-1"
}

variable "cluster_name" {
  description = "eks clustr name"
  type = string
  default = "dev-eks cluster"
}

variable "vpc_cidr" {
  description = "CIDR VPC block"
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "public subnets"
  type = list(string)
  default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "private_subnets" {
  description = "private subnets"
  type = list(string)
  default = ["10.0.3.0/24","10.0.4.0/24"]
}

variable "node_instance_type" {
  description = "EC2 instance type for eks nodes"
  type = string
  default = "t3.small"
}

variable "node-desired" {
  description = "Desired number of worker nodes"
  type = number
  default = 1
}

variable "node_min" {
  description = "minikumm number of ndole count worker nodes"
  type = number
  default = 0
}

variable "node_max" {
  description = "maximum worker nodes"
  type = number
  default = 2
}

variable "availability_zones" {
  description = "list of az for subnets"
  type = list(string)
  default = ["us-east-1a","us-east-1b"]
}

variable "ssh_key_name" {
  description = "SSH key pair name for EC2 worker nodes (optional)"
  type        = string
  default     = ""  # leave empty if not using SSH
}