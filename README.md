# Terraform-deployment

#here we  are deployed ec2 instance using terraform 
#first enabled communication between local envirnment and aws using aws credentials
"$ aws configure
AWS Access Key ID [****************XTSZ]:
AWS Secret Access Key [****************29KE]: 
Default region name [us-east-1]: 
Default output format [None]: "

terraform commands#

terraform init
terraform plan
terraform apply --auto-apporve

#statefile stored locally for testing purpose
