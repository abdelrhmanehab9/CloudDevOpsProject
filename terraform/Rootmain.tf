# ============================================
# File: terraform/main.tf
# Purpose: Root module - Orchestrates all modules
# ============================================

# -------------------
# Terraform Configuration
# -------------------
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# -------------------
# AWS Provider
# -------------------
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "CloudDevOpsProject"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# -------------------
# Network Module
# -------------------
module "network" {
  source = "./modules/network"

  vpc_cidr            = var.vpc_cidr
  project_name        = var.project_name
  environment         = var.environment
  availability_zones  = var.availability_zones
  public_subnet_cidrs = var.public_subnet_cidrs
}

# -------------------
# Server Module (Jenkins)
# -------------------
module "server" {
  source = "./modules/server"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  instance_type     = var.jenkins_instance_type
  key_name          = var.key_name
  jenkins_port      = var.jenkins_port
}

# -------------------
# EKS Module (Bonus)
# -------------------
module "eks" {
  source = "./modules/eks"

  cluster_name        = "${var.project_name}-${var.environment}-cluster"
  cluster_version     = var.eks_cluster_version
  vpc_id              = module.network.vpc_id
  subnet_ids          = module.network.public_subnet_ids
  node_instance_types = var.eks_node_instance_types
  desired_size        = var.eks_desired_size
  min_size            = var.eks_min_size
  max_size            = var.eks_max_size
}
