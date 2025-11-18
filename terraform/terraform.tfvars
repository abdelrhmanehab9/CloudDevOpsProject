# ============================================
# File: terraform/terraform.tfvars
# Purpose: Actual variable values for your deployment
# IMPORTANT: Add this file to .gitignore for security
# ============================================

# -------------------
# AWS Configuration
# -------------------
aws_region = "us-east-1"
 # Change to your preferred region

# -------------------
# Project Configuration
# -------------------
project_name = "CloudDevOpsProject"
environment  = "dev"

# -------------------
# Network Configuration
# -------------------
vpc_cidr            = "10.0.0.0/16"
availability_zones  = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

# -------------------
# Jenkins Configuration
# -------------------
jenkins_instance_type = "t3.micro"
key_name              = "abdelrhman-key" 
jenkins_port          = 8080

# -------------------
# EKS Configuration (Bonus)
# -------------------
eks_cluster_version     = "1.30"
eks_node_instance_types = ["t3.micro"]
eks_desired_size        = 2
eks_min_size            = 1
eks_max_size            = 3

# ============================================
# IMPORTANT NOTES:
# ============================================
# 1. Change "your-key-pair-name" to your actual AWS key pair name
# 2. Make sure the key pair exists in the region you're deploying to
# 3. Add terraform.tfvars to .gitignore to avoid committing sensitive data
# 4. Adjust instance types based on your workload needs
# 5. Consider costs before setting eks_desired_size, min_size, max_size
# ============================================
