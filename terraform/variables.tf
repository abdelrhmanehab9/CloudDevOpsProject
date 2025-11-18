# ============================================
# File: terraform/variables.tf
# Purpose: Root variable definitions
# ============================================

# -------------------
# AWS Configuration
# -------------------
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# -------------------
# Project Configuration
# -------------------
variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "CloudDevOpsProject"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# -------------------
# Network Configuration
# -------------------
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# -------------------
# Jenkins Configuration
# -------------------
variable "jenkins_instance_type" {
  description = "EC2 instance type for Jenkins"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "jenkins_port" {
  description = "Jenkins web interface port"
  type        = number
  default     = 8080
}

# -------------------
# EKS Configuration (Bonus)
# -------------------
variable "eks_cluster_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.30"
}

variable "eks_node_instance_types" {
  description = "Instance types for EKS node group"
  type        = list(string)
  default     = ["t3.micro"]
}

variable "eks_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "eks_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "eks_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}
