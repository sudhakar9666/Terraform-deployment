output "vpc_id" {
  value = aws_vpc.myvpc.id
}

output "public_subnet_id" {
  value = aws_subnet.my-subnet.id
}

output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

output "ec2_ssh_command" {
  value = "ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${aws_instance.web.public_ip}"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.my-bucket.bucket
}

output "secret_arn" {
  value = aws_secretsmanager_secret.app_secret.arn
}
