# Main Terraform Configuration
# This file orchestrates all modules for the InnovateMart EKS deployment

locals {
  cluster_name = "${var.project_name}-${var.environment}-eks"

  common_tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      Region      = var.aws_region
    }
  )
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  cluster_name         = local.cluster_name
  region               = var.aws_region
  tags                 = local.common_tags
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  cluster_name       = local.cluster_name
  cluster_version    = var.cluster_version
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  node_instance_type = var.node_instance_type
  node_desired_size  = var.node_desired_size
  node_min_size      = var.node_min_size
  node_max_size      = var.node_max_size
  tags               = local.common_tags

  depends_on = [module.vpc]
}

# IAM Module
module "iam" {
  source = "./modules/iam"

  developer_username     = var.developer_username
  cluster_name           = local.cluster_name
  cluster_arn            = module.eks.cluster_id
  node_instance_role_arn = module.eks.node_group_role_arn
  tags                   = local.common_tags

  depends_on = [module.eks]
}
