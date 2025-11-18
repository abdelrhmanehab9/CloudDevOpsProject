# ============================================
# File: terraform/outputs.tf
# Purpose: Root outputs - Display important information
# ============================================

# -------------------
# Network Outputs
# -------------------
output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.network.public_subnet_ids
}

# -------------------
# Jenkins Outputs
# -------------------
output "jenkins_instance_id" {
  description = "Jenkins EC2 instance ID"
  value       = module.server.instance_id
}

output "jenkins_public_ip" {
  description = "Jenkins EC2 public IP"
  value       = module.server.public_ip
}

output "jenkins_url" {
  description = "Jenkins access URL"
  value       = "http://${module.server.public_ip}:${var.jenkins_port}"
}

output "jenkins_security_group_id" {
  description = "Jenkins security group ID"
  value       = module.server.security_group_id
}

output "jenkins_ssh_command" {
  description = "SSH command to connect to Jenkins"
  value       = "ssh -i ${var.key_name}.pem ec2-user@${module.server.public_ip}"
}

# -------------------
# EKS Outputs (Bonus)
# -------------------
output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value       = module.eks.cluster_security_group_id
}

output "eks_configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}
