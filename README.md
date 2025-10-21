# InnovateMart Project Bedrock 🚀

## Overview
Project Bedrock is InnovateMart's inaugural Amazon EKS deployment, establishing the foundation for our microservices architecture on AWS.

## Architecture
This project deploys the retail-store-sample-app on Amazon EKS with full infrastructure automation using Terraform.

### Components
- **VPC**: Custom VPC with public and private subnets across multiple AZs
- **EKS Cluster**: Managed Kubernetes cluster on AWS
- **Microservices**: Complete retail application with UI, catalog, orders, carts, checkout, and assets services
- **CI/CD**: GitHub Actions pipeline for automated infrastructure deployment

## Project Structure
```
innovatemart-bedrock/
├── .github/workflows/    # CI/CD pipelines
├── terraform/            # Infrastructure as Code
│   ├── modules/         # Reusable Terraform modules
│   └── environments/    # Environment-specific configs
├── kubernetes/          # Kubernetes manifests
├── scripts/            # Automation scripts
└── docs/               # Documentation
```

## Prerequisites
- AWS Account with appropriate permissions
- AWS CLI configured
- Terraform >= 1.0
- kubectl
- Git

## Quick Start
## 🎉 Current Deployment Status

**Status:** ✅ DEPLOYED & RUNNING

**Application URL:** http://affdf3446d42c4279909643ba8a2c52e-1350286023.us-east-1.elb.amazonaws.com

**Deployment Date:** October 21, 2025  
**Environment:** Production  
**Region:** us-east-1  
**Cluster:** innovatemart-prod-eks  

### Quick Access
- **Application:** [Open Retail Store](http://affdf3446d42c4279909643ba8a2c52e-1350286023.us-east-1.elb.amazonaws.com)
- **Topology View:** [/topology](http://affdf3446d42c4279909643ba8a2c52e-1350286023.us-east-1.elb.amazonaws.com/topology)
- **Infrastructure Info:** [/info](http://affdf3446d42c4279909643ba8a2c52e-1350286023.us-east-1.elb.amazonaws.com/info)

### Infrastructure Details
- **3 EKS Nodes:** t3.medium across 3 availability zones
- **VPC CIDR:** 10.0.0.0/16
- **Microservices:** UI, Catalog, Carts, Orders, Checkout, Assets
- **CI/CD:** GitHub Actions automated pipeline

### 1. Clone the Repository
```bash
git clone https://github.com/YOUR_USERNAME/innovatemart-bedrock.git
cd innovatemart-bedrock
```

### 2. Configure AWS Credentials
```bash
aws configure
```

### 3. Deploy Infrastructure
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 4. Configure kubectl
```bash
aws eks update-kubeconfig --name innovatemart-eks --region us-east-1
```

### 5. Verify Deployment
```bash
kubectl get nodes
kubectl get pods -A
```

## Access Instructions

### Developer Read-Only Access
Instructions for IAM user configuration will be provided after deployment.

### Application URL
The application will be accessible via the LoadBalancer URL after deployment:
```bash
kubectl get svc -n retail
```

## CI/CD Pipeline

This project uses GitHub Actions for automated infrastructure deployment:
- **Feature branches**: Trigger `terraform plan`
- **Main branch**: Trigger `terraform apply`

## Security Notes
- Never commit sensitive data (AWS keys, certificates, passwords)
- Use AWS Secrets Manager for sensitive configuration
- IAM roles follow least privilege principle

## Bonus Features Implemented
- [ ] AWS RDS for PostgreSQL (orders service)
- [ ] AWS RDS for MySQL (catalog service)
- [ ] Amazon DynamoDB (carts service)
- [ ] AWS Load Balancer Controller
- [ ] Ingress with ALB
- [ ] Custom domain with Route53
- [ ] SSL/TLS with ACM

## Documentation
- [Architecture Guide](docs/architecture.md)
- [Deployment Guide](docs/deployment.md)

## Team
- **Cloud DevOps Engineer**: [Your Name]
- **Company**: InnovateMart Inc.
- **Project**: Bedrock

## License
Proprietary - InnovateMart Inc.

---
Built with ☁️ by InnovateMart Cloud Engineering Team
