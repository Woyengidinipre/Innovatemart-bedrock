# modules/iam/main.tf

# Caller identity so we can build ARNs
data "aws_caller_identity" "current" {}

# Local values
locals {
  eks_cluster_arn = "arn:aws:eks:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${var.cluster_name}"
  name_prefix     = var.cluster_name
}

# IAM User for Developer (Read-Only Access)
resource "aws_iam_user" "developer" {
  name = var.developer_username
  path = "/developers/"

  tags = merge(
    var.tags,
    {
      Name        = var.developer_username
      Description = "Read-only developer access to EKS cluster"
    }
  )
}

# Access Key for Developer User
resource "aws_iam_access_key" "developer" {
  user = aws_iam_user.developer.name
}

# IAM Policy for Read-Only EKS Access
resource "aws_iam_policy" "developer_eks_readonly" {
  name        = "${local.name_prefix}-developer-readonly-policy"
  description = "Read-only access to EKS cluster resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:ListUpdates",
          "eks:AccessKubernetesApi"
        ]
        Resource = [ local.eks_cluster_arn ]
      },
      {
        Effect = "Allow"
        Action = [
          "eks:ListClusters"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

# Attach Policy to Developer User
resource "aws_iam_user_policy_attachment" "developer_eks_readonly" {
  user       = aws_iam_user.developer.name
  policy_arn = aws_iam_policy.developer_eks_readonly.arn
}

# IAM Role for Developer with Read-Only Kubernetes Access
resource "aws_iam_role" "developer_eks_role" {
  name = "${local.name_prefix}-developer-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_user.developer.arn
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${local.name_prefix}-developer-role"
    }
  )
}

# Policy for the Developer Role (allows EKS access)
resource "aws_iam_role_policy" "developer_eks_access" {
  name = "eks-access"
  role = aws_iam_role.developer_eks_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Resource = "*"
      }
    ]
  })
}

# ConfigMap for aws-auth (Kubernetes RBAC) - generated file
resource "local_file" "aws_auth_configmap" {
  content = templatefile("${path.module}/templates/aws-auth-configmap.yaml.tpl", {
    node_instance_role_arn = var.node_instance_role_arn
    developer_role_arn     = aws_iam_role.developer_eks_role.arn
    developer_username     = var.developer_username
  })
  filename = "${path.module}/../../generated/aws-auth-configmap.yaml"
}

# Kubernetes RBAC Role for Read-Only Access - generated file
resource "local_file" "developer_rbac_role" {
  content = templatefile("${path.module}/templates/developer-rbac.yaml.tpl", {
    developer_username = var.developer_username
  })
  filename = "${path.module}/../../generated/developer-rbac.yaml"
}

# KMS Key for encrypting SSM SecureString parameters
resource "aws_kms_key" "ssm" {
  description             = "KMS key for SSM parameters for ${local.name_prefix}"
  deletion_window_in_days = 7

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowAccountRoot"
        Effect    = "Allow"
        Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
        Action    = "kms:*"
        Resource  = "*"
      },
      {
        Sid = "AllowSSMServiceUse"
        Effect = "Allow"
        Principal = {
          Service = "ssm.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

# Store developer credentials securely in AWS Systems Manager Parameter Store (SecureString with KMS)
resource "aws_ssm_parameter" "developer_access_key" {
  name        = "/${local.name_prefix}/developer/access-key-id"
  description = "Access Key ID for developer user"
  type        = "SecureString"
  value       = aws_iam_access_key.developer.id
  key_id      = aws_kms_key.ssm.key_id
  tags        = var.tags

  depends_on = [ aws_kms_key.ssm ]
}

resource "aws_ssm_parameter" "developer_secret_key" {
  name        = "/${local.name_prefix}/developer/secret-access-key"
  description = "Secret Access Key for developer user"
  type        = "SecureString"
  value       = aws_iam_access_key.developer.secret
  key_id      = aws_kms_key.ssm.key_id
  tags        = var.tags

  depends_on = [ aws_kms_key.ssm ]
}
