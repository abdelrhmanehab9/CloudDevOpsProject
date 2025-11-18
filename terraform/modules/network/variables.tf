# ============================================
# File: terraform/modules/network/variables.tf
# Purpose: Variable definitions for Network Module
# ============================================

# VPC CIDR Block
# Example: "10.0.0.0/16"
variable "vpc_cidr" {
  description = "CIDR block for the main VPC"
  type        = string
}

# Project name (used in resource naming and tags)
# Example: "CloudDevOpsProject"
variable "project_name" {
  description = "Project name - used in tags and resource naming"
  type        = string
}

# Environment name
# Example: "dev", "staging", "prod"
variable "environment" {
  description = "Environment name (dev, staging, production)"
  type        = string
}

# List of Availability Zones
# Example: ["us-east-1a", "us-east-1b"]
variable "availability_zones" {
  description = "List of Availability Zones for deployment"
  type        = list(string)
}

# List of CIDR blocks for Public Subnets
# Example: ["10.0.1.0/24", "10.0.2.0/24"]
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

# Note: Number of public_subnet_cidrs must match number of availability_zones
