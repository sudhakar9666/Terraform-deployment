output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_certificate" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "worker_sg_id" {
  value = aws_security_group.eks_worker_sg.id
}

output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}
