terraform {
  backend "s3" {
    bucket         = "my-terraform-state-565871519906" # EDIT
    key            = "infra/terraform.tfstate"                 # EDIT if you want
    region         = "us-east-1"                               # EDIT
    dynamodb_table = "tf-locks"                               # EDIT
    encrypt        = true
  }
}
