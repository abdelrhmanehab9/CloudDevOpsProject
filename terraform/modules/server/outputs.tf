# ============================================
# File: terraform/modules/server/outputs.tf
# Purpose: Export values from Server Module
# ============================================

output "instance_id" {
  description = "Jenkins EC2 instance ID"
  value       = aws_instance.jenkins.id
}

output "public_ip" {
  description = "Jenkins EC2 public IP address"
  value       = aws_instance.jenkins.public_ip
}

output "private_ip" {
  description = "Jenkins EC2 private IP address"
  value       = aws_instance.jenkins.private_ip
}

output "security_group_id" {
  description = "Security group ID for Jenkins"
  value       = aws_security_group.jenkins.id
}

output "iam_role_arn" {
  description = "IAM role ARN for Jenkins instance"
  value       = aws_iam_role.jenkins.arn
}

output "instance_profile_name" {
  description = "IAM instance profile name"
  value       = aws_iam_instance_profile.jenkins.name
}
