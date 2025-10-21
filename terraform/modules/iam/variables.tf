variable "developer_username" {
  description = "IAM username for the read-only developer"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_arn" {
  description = "ARN of the EKS cluster"
  type        = string
}

variable "node_instance_role_arn" {
  description = "IAM role ARN for EKS node instances"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

