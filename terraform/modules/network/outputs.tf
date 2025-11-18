# ============================================
# File: terraform/modules/network/outputs.tf
# Purpose: Export values from Network Module
# These outputs will be used by other modules (Server, EKS)
# ============================================

# -------------------
# VPC Outputs
# -------------------

# VPC ID
# Example: vpc-0a1b2c3d4e5f6g7h8
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

# VPC CIDR Block
# Example: 10.0.0.0/16
output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# -------------------
# Subnets Outputs
# -------------------

# List of Public Subnet IDs
# Example: ["subnet-abc123", "subnet-def456"]
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

# -------------------
# Internet Gateway Output
# -------------------

# Internet Gateway ID
# Example: igw-abc123def456
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

# -------------------
# Route Table Output
# -------------------

# Public Route Table ID
# Example: rtb-abc123def456
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

# -------------------
# Network ACL Output
# -------------------

# Network ACL ID
# Example: acl-abc123def456
output "network_acl_id" {
  description = "ID of the Network ACL"
  value       = aws_network_acl.main.id
}

# Note: These outputs are used by:
# - Server Module: requires vpc_id and public_subnet_ids
# - EKS Module: requires vpc_id and public_subnet_ids
