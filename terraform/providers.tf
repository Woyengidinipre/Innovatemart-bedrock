provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "InnovateMart-Bedrock"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "CloudDevOps"
    }
  }
}

# Kubernetes provider configuration
# This will be configured after EKS cluster is created
provider "kubernetes" {
  host                   = try(module.eks.cluster_endpoint, "")
  cluster_ca_certificate = try(base64decode(module.eks.cluster_certificate_authority_data), "")
  
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      try(module.eks.cluster_name, "")
    ]
  }
}

# Helm provider configuration
provider "helm" {
  kubernetes {
    host                   = try(module.eks.cluster_endpoint, "")
    cluster_ca_certificate = try(base64decode(module.eks.cluster_certificate_authority_data), "")
    
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        try(module.eks.cluster_name, "")
      ]
    }
  }
}

# Data source to get current AWS account information
data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}
