# ============================================
# File: terraform/modules/network/main.tf
# Purpose: Network infrastructure setup
# Contains: VPC, Internet Gateway, Subnets, Route Tables, Network ACL
# ============================================

# -------------------
# 1. VPC Creation
# -------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# -------------------
# 2. Internet Gateway
# -------------------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

# -------------------
# 3. Public Subnets
# -------------------
# Creates one subnet per CIDR in the list
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet-${count.index + 1}"
    "kubernetes.io/role/elb" = "1"  # For EKS Load Balancers
  }
}

# -------------------
# 4. Route Table for Public Subnets
# -------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # Route all traffic to the internet via IGW
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public-rt"
  }
}

# -------------------
# 5. Route Table Associations
# -------------------
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# -------------------
# 6. Network ACL
# -------------------
resource "aws_network_acl" "main" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.public[*].id

  # Allow all inbound traffic
  ingress {
    protocol   = -1        # All protocols
    rule_no    = 100       # Rule number
    action     = "allow"   # Allow action
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Allow all outbound traffic
  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-nacl"
  }
}
