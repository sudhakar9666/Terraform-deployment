variable "Project_name" {
  default = "my-terraform-project"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "instance_type" {
  default = "t3.micro"
}
#here we are using existing key##
variable "key_name" {
  description = "using my existing key"
  default = "mykeypair"
}

variable "s3_bucket_name" {
  default = "myterraformprojectbucket001"
}

variable "secret_name" {
  default = "my-app-secret"
}

###################################
# EC2 Instance
###################################
