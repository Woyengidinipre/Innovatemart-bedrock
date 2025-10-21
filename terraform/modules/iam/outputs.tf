output "developer_user_arn" {
  description = "ARN of the developer IAM user"
  value       = aws_iam_user.developer.arn
}

output "developer_user_name" {
  description = "Name of the developer IAM user"
  value       = aws_iam_user.developer.name
}

output "developer_access_key_id" {
  description = "Access key ID for the developer user"
  value       = aws_iam_access_key.developer.id
  sensitive   = true
}

output "developer_secret_access_key" {
  description = "Secret access key for the developer user"
  value       = aws_iam_access_key.developer.secret
  sensitive   = true
}

output "developer_role_arn" {
  description = "ARN of the developer IAM role"
  value       = aws_iam_role.developer_eks_role.arn
}

output "developer_role_name" {
  description = "Name of the developer IAM role"
  value       = aws_iam_role.developer_eks_role.name
}

output "aws_auth_configmap_file" {
  description = "Path to the generated aws-auth ConfigMap file"
  value       = local_file.aws_auth_configmap.filename
}

output "developer_rbac_file" {
  description = "Path to the generated developer RBAC file"
  value       = local_file.developer_rbac_role.filename
}
