# InnovateMart Architecture Documentation

## System Architecture

### High-Level Overview
```
┌─────────────────────────────────────────────────────────┐
│                    AWS Cloud (Region)                    │
│  ┌───────────────────────────────────────────────────┐  │
│  │                      VPC                          │  │
│  │  ┌──────────────────┐    ┌────────────────────┐  │  │
│  │  │  Public Subnets  │    │  Private Subnets   │  │  │
│  │  │                  │    │                    │  │  │
│  │  │  - NAT Gateway   │    │  - EKS Nodes       │  │  │
│  │  │  - Internet GW   │    │  - Application     │  │  │
│  │  │                  │    │    Pods            │  │  │
│  │  └──────────────────┘    └────────────────────┘  │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

## Network Architecture

### VPC Configuration
- **CIDR Block**: 10.0.0.0/16
- **Availability Zones**: 3 AZs for high availability
- **Public Subnets**: 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24
- **Private Subnets**: 10.0.11.0/24, 10.0.12.0/24, 10.0.13.0/24

### Connectivity
- Internet Gateway for public subnet internet access
- NAT Gateway in each public subnet for private subnet outbound traffic
- VPC Endpoints for AWS services (S3, ECR, etc.)

## EKS Cluster Architecture

### Control Plane
- Managed by AWS
- Multi-AZ deployment for high availability
- API server endpoint: Public (with IP restrictions recommended)

### Data Plane (Worker Nodes)
- **Node Type**: t3.medium (2 vCPU, 4GB RAM)
- **Scaling**: Auto-scaling group (Min: 2, Max: 6, Desired: 3)
- **Placement**: Private subnets across multiple AZs

## Application Architecture

### Microservices Components

#### Frontend
- **UI Service**: React-based web interface

#### Backend Services
- **Catalog Service**: Product management (MySQL)
- **Orders Service**: Order processing (PostgreSQL)
- **Carts Service**: Shopping cart (DynamoDB Local)
- **Checkout Service**: Payment processing
- **Assets Service**: Static content delivery

#### Supporting Services (In-Cluster)
- **MySQL**: Catalog database
- **PostgreSQL**: Orders database
- **DynamoDB Local**: Carts database
- **Redis**: Caching layer
- **RabbitMQ**: Message queue

### Service Communication
- Internal cluster DNS for service discovery
- ClusterIP services for internal communication
- LoadBalancer service for external access to UI

## Security Architecture

### IAM Roles
- **EKS Cluster Role**: Manages EKS control plane
- **Node Instance Role**: EC2 permissions for worker nodes
- **Developer Read-Only Role**: Limited access for dev team

### Network Security
- Security groups controlling ingress/egress
- Network ACLs at subnet level
- Pod Security Policies (future implementation)

## Deployment Strategy

### Phase 1: Core Infrastructure
1. VPC and networking
2. EKS cluster
3. IAM roles and policies

### Phase 2: Application Deployment
1. Deploy supporting services (databases, caching)
2. Deploy microservices
3. Configure service exposure

### Phase 3: Observability (Future)
1. CloudWatch integration
2. Container Insights
3. Application monitoring

## Disaster Recovery

### Backup Strategy
- EKS cluster configuration in Terraform
- Application manifests in Git
- Database backups (when using RDS - bonus)

### Recovery Time Objective (RTO)
- Target: < 1 hour for complete infrastructure recreation

### Recovery Point Objective (RPO)
- In-cluster databases: Best effort
- RDS databases: Point-in-time recovery available

## Scaling Strategy

### Horizontal Scaling
- Kubernetes HPA for application pods
- Cluster Autoscaler for worker nodes

### Vertical Scaling
- Node instance type can be upgraded via Terraform

## Cost Optimization

### Current Estimates (Monthly)
- EKS Cluster: $73
- EC2 Instances (3x t3.medium): ~$90
- NAT Gateway: ~$100
- Data Transfer: Variable
- **Estimated Total**: ~$270-$300/month

### Optimization Opportunities
- Use Spot Instances for non-critical workloads
- Implement pod resource limits
- Review and optimize data transfer

---
**Document Version**: 1.0  
**Last Updated**: October 2025  
**Author**: Cloud DevOps Team
