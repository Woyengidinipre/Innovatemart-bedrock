# Terraform Backend Configuration for S3
# 
# IMPORTANT: Before using this backend, you need to:
# 1. Create an S3 bucket for state storage
# 2. Create a DynamoDB table for state locking
#
# Run these AWS CLI commands first:
#
# aws s3api create-bucket \
#   --bucket innovatemart-terraform-state-<your-account-id> \
#   --region us-east-1
#
# aws s3api put-bucket-versioning \
#   --bucket innovatemart-terraform-state-<your-account-id> \
#   --versioning-configuration Status=Enabled
#
# aws s3api put-bucket-encryption \
#   --bucket innovatemart-terraform-state-<your-account-id> \
#   --server-side-encryption-configuration '{
#     "Rules": [{
#       "ApplyServerSideEncryptionByDefault": {
#         "SSEAlgorithm": "AES256"
#       }
#     }]
#   }'
#
# aws dynamodb create-table \
#   --table-name innovatemart-terraform-locks \
#   --attribute-definitions AttributeName=LockID,AttributeType=S \
#   --key-schema AttributeName=LockID,KeyType=HASH \
#   --billing-mode PAY_PER_REQUEST \
#   --region us-east-1

# INITIAL SETUP: Comment out this entire backend block for first run
# After creating S3 bucket and DynamoDB table, uncomment and run:
# terraform init -migrate-state

# terraform {
#   backend "s3" {
#     bucket         = "innovatemart-terraform-state-REPLACE-WITH-ACCOUNT-ID"
#     key            = "prod/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "innovatemart-terraform-locks"
#   }
# }

# For now, we'll use local backend (default)
# State will be stored in terraform.tfstate file locally
