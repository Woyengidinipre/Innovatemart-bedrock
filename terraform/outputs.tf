output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "eks_cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "eks_node_group_id" {
  description = "EKS node group ID"
  value       = module.eks.node_group_id
}

output "eks_node_group_role_arn" {
  description = "IAM role ARN for EKS node group"
  value       = module.eks.node_group_role_arn
}

output "developer_user_arn" {
  description = "ARN of the read-only developer IAM user"
  value       = module.iam.developer_user_arn
}

output "developer_user_name" {
  description = "Name of the read-only developer IAM user"
  value       = module.iam.developer_user_name
}

output "developer_access_key_id" {
  description = "Access key ID for developer user (sensitive)"
  value       = module.iam.developer_access_key_id
  sensitive   = true
}

output "developer_secret_access_key" {
  description = "Secret access key for developer user (sensitive)"
  value       = module.iam.developer_secret_access_key
  sensitive   = true
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}
