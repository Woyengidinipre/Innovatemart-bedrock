\# InnovateMart Project Bedrock - Deployment \& Architecture Guide



\## Table of Contents

1\. \[Overview](#overview)

2\. \[Architecture](#architecture)

3\. \[Infrastructure Components](#infrastructure-components)

4\. \[Deployment Instructions](#deployment-instructions)

5\. \[Accessing the Application](#accessing-the-application)

6\. \[Developer Access](#developer-access)

7\. \[CI/CD Pipeline](#cicd-pipeline)

8\. \[Monitoring \& Maintenance](#monitoring--maintenance)



---



\## Overview



\*\*Project Name:\*\* InnovateMart Project Bedrock  

\*\*Objective:\*\* Deploy retail-store-sample-app on Amazon EKS with full automation  

\*\*Region:\*\* us-east-1  

\*\*Environment:\*\* Production  



\### Key Achievements

✅ Fully automated infrastructure deployment using Terraform  

✅ Production-grade EKS cluster with multi-AZ deployment  

✅ Complete microservices application deployed  

✅ Read-only developer access configured  

✅ CI/CD pipeline with GitHub Actions  



---



\## Architecture



\### High-Level Architecture Diagram



```

┌─────────────────────────────────────────────────────────────┐

│                     AWS Account (us-east-1)                  │

│  ┌───────────────────────────────────────────────────────┐  │

│  │                  VPC (10.0.0.0/16)                    │  │

│  │  ┌──────────────────────┐  ┌──────────────────────┐  │  │

│  │  │   Public Subnets     │  │   Private Subnets    │  │  │

│  │  │   (3 AZs)            │  │   (3 AZs)            │  │  │

│  │  │                      │  │                      │  │  │

│  │  │  - Internet Gateway  │  │  - EKS Worker Nodes  │  │  │

│  │  │  - NAT Gateways (3)  │  │  - Application Pods  │  │  │

│  │  │  - LoadBalancer      │  │  - Databases         │  │  │

│  │  └──────────────────────┘  └──────────────────────┘  │  │

│  │                                                        │  │

│  │         ┌────────────────────────────┐                │  │

│  │         │   EKS Control Plane        │                │  │

│  │         │   (Managed by AWS)         │                │  │

│  │         └────────────────────────────┘                │  │

│  └───────────────────────────────────────────────────────┘  │

│                                                              │

│  ┌───────────────────────────────────────────────────────┐  │

│  │              IAM \& Security                           │  │

│  │  - Cluster IAM Roles                                  │  │

│  │  - Node IAM Roles                                     │  │

│  │  - Developer Read-Only User                           │  │

│  │  - Security Groups                                    │  │

│  └───────────────────────────────────────────────────────┘  │

└─────────────────────────────────────────────────────────────┘

```



\### Network Architecture



\*\*VPC Configuration:\*\*

\- \*\*CIDR:\*\* 10.0.0.0/16

\- \*\*Public Subnets:\*\* 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24 (us-east-1a, 1b, 1c)

\- \*\*Private Subnets:\*\* 10.0.11.0/24, 10.0.12.0/24, 10.0.13.0/24 (us-east-1a, 1b, 1c)

\- \*\*Internet Gateway:\*\* For public subnet internet access

\- \*\*NAT Gateways:\*\* One per AZ for private subnet outbound traffic

\- \*\*VPC Endpoints:\*\* S3 endpoint for cost optimization



\### Application Architecture



\*\*Microservices Deployed:\*\*



```

┌─────────────────────────────────────────────────┐

│                  Internet                        │

└────────────────────┬────────────────────────────┘

&nbsp;                    │

&nbsp;                    ▼

&nbsp;         ┌──────────────────┐

&nbsp;         │  LoadBalancer    │

&nbsp;         │  (AWS ELB)       │

&nbsp;         └─────────┬────────┘

&nbsp;                   │

&nbsp;                   ▼

&nbsp;         ┌──────────────────┐

&nbsp;         │   UI Service     │  ◄─── Frontend (Java)

&nbsp;         └─────────┬────────┘

&nbsp;                   │

&nbsp;       ┌───────────┼───────────┬──────────────┐

&nbsp;       │           │           │              │

&nbsp;       ▼           ▼           ▼              ▼

&nbsp;  ┌────────┐  ┌────────┐  ┌────────┐   ┌─────────┐

&nbsp;  │Catalog │  │ Carts  │  │Orders  │   │Checkout │

&nbsp;  │(Go)    │  │(Java)  │  │(Java)  │   │(Node)   │

&nbsp;  └───┬────┘  └───┬────┘  └───┬────┘   └────┬────┘

&nbsp;      │           │           │              │

&nbsp;      ▼           ▼           ▼              ▼

&nbsp;  ┌────────┐  ┌────────┐  ┌────────┐   ┌─────────┐

&nbsp;  │ MySQL  │  │DynamoDB│  │Postgres│   │  Redis  │

&nbsp;  │        │  │ Local  │  │        │   │         │

&nbsp;  └────────┘  └────────┘  └────────┘   └─────────┘

```



---



\## Infrastructure Components



\### 1. VPC Resources



| Resource | Count | Purpose |

|----------|-------|---------|

| VPC | 1 | Network isolation |

| Public Subnets | 3 | LoadBalancers, NAT Gateways |

| Private Subnets | 3 | EKS worker nodes, application pods |

| Internet Gateway | 1 | Public internet access |

| NAT Gateways | 3 | Private subnet outbound traffic |

| Route Tables | 4 | Traffic routing (1 public, 3 private) |

| S3 VPC Endpoint | 1 | Cost optimization |



\### 2. EKS Cluster



| Component | Configuration |

|-----------|---------------|

| Cluster Name | innovatemart-prod-eks |

| Kubernetes Version | 1.28 |

| Control Plane | Managed by AWS (Multi-AZ) |

| API Endpoint | Public with security groups |

| Logging | CloudWatch (API, Audit, Authenticator, Controller Manager, Scheduler) |



\### 3. EKS Node Group



| Setting | Value |

|---------|-------|

| Instance Type | t3.medium (2 vCPU, 4GB RAM) |

| Desired Capacity | 3 nodes |

| Minimum | 2 nodes |

| Maximum | 6 nodes |

| AMI Type | Amazon Linux 2 |

| Disk Size | 20 GB (encrypted) |

| Placement | Private subnets across 3 AZs |



\### 4. Security Configuration



\*\*Security Groups:\*\*

\- EKS Cluster Security Group (port 443 for API access)

\- Node Security Group (inter-node communication, cluster access)



\*\*IAM Roles:\*\*

\- EKS Cluster Role (AmazonEKSClusterPolicy, AmazonEKSVPCResourceController)

\- EKS Node Role (AmazonEKSWorkerNodePolicy, AmazonEKS\_CNI\_Policy, AmazonEC2ContainerRegistryReadOnly)

\- Developer Read-Only Role (EKS describe permissions)



\*\*IAM Users:\*\*

\- innovatemart-developer (read-only access to cluster)



\### 5. Application Resources



| Service | Replicas | Database | Purpose |

|---------|----------|----------|---------|

| UI | 1 | - | Frontend interface |

| Catalog | 1 | MySQL | Product catalog |

| Carts | 1 | DynamoDB Local | Shopping carts |

| Orders | 1 | PostgreSQL + RabbitMQ | Order processing |

| Checkout | 1 | Redis | Checkout orchestration |

| Assets | 1 | - | Static content |



---



\## Deployment Instructions



\### Prerequisites

\- AWS CLI configured with appropriate credentials

\- Terraform >= 1.0 installed

\- kubectl installed

\- Git installed



\### Step 1: Clone Repository



```bash

git clone https://github.com/YOUR\_USERNAME/innovatemart-bedrock.git

cd innovatemart-bedrock/terraform

```



\### Step 2: Review Variables



Edit `variables.tf` if you want to customize:

\- AWS region (default: us-east-1)

\- Node instance types

\- Cluster version

\- VPC CIDR blocks



\### Step 3: Initialize Terraform



```bash

terraform init

```



\### Step 4: Plan Infrastructure



```bash

terraform plan

```



Review the plan output carefully. You should see ~45-50 resources to be created.



\### Step 5: Apply Infrastructure



```bash

terraform apply

```



Type `yes` when prompted. Deployment takes approximately 15-20 minutes.



\### Step 6: Configure kubectl



```bash

aws eks update-kubeconfig --name innovatemart-prod-eks --region us-east-1

```



\### Step 7: Verify Cluster Access



```bash

kubectl get nodes

```



You should see 3 nodes in "Ready" state.



\### Step 8: Apply AWS Auth ConfigMap



```bash

kubectl apply -f generated/aws-auth-configmap.yaml

kubectl apply -f generated/developer-rbac.yaml

```



\### Step 9: Deploy Application



```bash

kubectl apply -f https://github.com/aws-containers/retail-store-sample-app/releases/latest/download/kubernetes.yaml

```



\### Step 10: Wait for Deployment



```bash

kubectl get pods --watch

```



Wait until all pods show "Running" status (3-5 minutes).



\### Step 11: Get Application URL



```bash

kubectl get svc ui

```



Look for the EXTERNAL-IP in the LoadBalancer service (takes 2-3 minutes to provision).



---



\## Accessing the Application



\### Public Access



\*\*Application URL:\*\* http://\[LOADBALANCER-DNS]



\*\*Current URL:\*\* http://affdf3446d42c4279909643ba8a2c52e-1350286023.us-east-1.elb.amazonaws.com



\*\*Features:\*\*

\- Browse product catalog

\- Add items to cart

\- Place orders

\- View application topology at `/topology`

\- View infrastructure metadata at `/info`



\### Health Checks



```bash

\# Check all pods

kubectl get pods



\# Check all services

kubectl get svc



\# Check deployments

kubectl get deployments



\# View pod logs

kubectl logs deployment/ui

```



---



\## Developer Access



\### IAM User Configuration



\*\*Username:\*\* innovatemart-developer  

\*\*ARN:\*\* arn:aws:iam::861276118104:user/developers/innovatemart-developer



\### Access Key Credentials



Credentials are stored securely in:

\- AWS Systems Manager Parameter Store

\- Local files (gitignored):

&nbsp; - `developer\_access\_key.txt`

&nbsp; - `developer\_secret\_key.txt`



\### Retrieve Developer Credentials



```bash

\# From Terraform outputs

terraform output -raw developer\_access\_key\_id

terraform output -raw developer\_secret\_access\_key



\# From AWS SSM Parameter Store

aws ssm get-parameter --name /innovatemart-prod-eks/developer/access-key-id --with-decryption

aws ssm get-parameter --name /innovatemart-prod-eks/developer/secret-access-key --with-decryption

```



\### Configure Developer Access



\*\*Step 1: Configure AWS CLI for developer\*\*



```bash

aws configure --profile innovatemart-developer

\# Enter access key ID

\# Enter secret access key

\# Region: us-east-1

\# Output: json

```



\*\*Step 2: Update kubeconfig\*\*



```bash

aws eks update-kubeconfig \\

&nbsp; --name innovatemart-prod-eks \\

&nbsp; --region us-east-1 \\

&nbsp; --profile innovatemart-developer

```



\*\*Step 3: Test Access\*\*



```bash

\# Should work (read-only)

kubectl get pods

kubectl get services

kubectl get deployments

kubectl describe pod ui

kubectl logs deployment/catalog



\# Should fail (no write access)

kubectl delete pod ui-xxxxx

kubectl scale deployment ui --replicas=2

```



\### Developer Permissions



\*\*Allowed Actions:\*\*

\- ✅ View pods, services, deployments

\- ✅ View logs

\- ✅ Describe resources

\- ✅ List namespaces

\- ✅ View configmaps (metadata only)

\- ✅ View events



\*\*Denied Actions:\*\*

\- ❌ Create/update/delete resources

\- ❌ Execute into pods

\- ❌ Port forwarding

\- ❌ View secrets content



---



\## CI/CD Pipeline



\### GitHub Actions Workflow



\*\*File:\*\* `.github/workflows/terraform.yml`



\### Workflow Jobs



\*\*1. Terraform Validate\*\* (All branches)

\- Format check

\- Syntax validation

\- Initialize Terraform



\*\*2. Terraform Plan\*\* (PRs and develop branch)

\- Generate execution plan

\- Post plan to PR comments

\- No infrastructure changes



\*\*3. Terraform Apply\*\* (main branch only)

\- Automatic deployment

\- Applies infrastructure changes

\- Posts results to commit



\### Branching Strategy



```

main (production)

&nbsp; │

&nbsp; ├─── develop (staging)

&nbsp; │      │

&nbsp; │      ├─── feature/add-monitoring

&nbsp; │      ├─── feature/update-node-type

&nbsp; │      └─── bugfix/security-group

&nbsp; │

&nbsp; └─── Direct merges trigger automatic deployment

```



\### Setup Instructions



\*\*1. Configure GitHub Secrets:\*\*

\- Go to repository Settings → Secrets and variables → Actions

\- Add `AWS\_ACCESS\_KEY\_ID`

\- Add `AWS\_SECRET\_ACCESS\_KEY`



\*\*2. Make a change:\*\*

```bash

git checkout -b feature/my-change

\# Make changes

git commit -m "Update infrastructure"

git push origin feature/my-change

```



\*\*3. Create Pull Request:\*\*

\- GitHub Actions runs validation and plan

\- Review the plan in PR comments



\*\*4. Merge to main:\*\*

\- Automatic `terraform apply` executes

\- Infrastructure is deployed



---



\## Monitoring \& Maintenance



\### CloudWatch Logs



EKS cluster logs are sent to CloudWatch:

\- API server logs

\- Audit logs

\- Authenticator logs

\- Controller manager logs

\- Scheduler logs



\*\*Access logs:\*\*

```bash

aws logs describe-log-groups --log-group-name-prefix /aws/eks/innovatemart-prod-eks

```



\### Resource Monitoring



```bash

\# Node resource usage

kubectl top nodes



\# Pod resource usage

kubectl top pods



\# View cluster events

kubectl get events --sort-by='.lastTimestamp'

```



\### Cost Monitoring



\*\*Estimated Monthly Costs:\*\*

\- EKS Cluster: $73/month

\- 3x t3.medium instances: ~$90/month

\- 3x NAT Gateways: ~$100/month

\- LoadBalancer: ~$20/month

\- Data transfer: Variable

\- \*\*Total: ~$280-320/month\*\*



\### Backup \& Disaster Recovery



\*\*Infrastructure:\*\*

\- All infrastructure is defined in Terraform (Infrastructure as Code)

\- Git repository serves as backup

\- Can recreate entire infrastructure with `terraform apply`



\*\*Application State:\*\*

\- In-cluster databases: No persistent backups (acceptable for demo)

\- For production: Use RDS with automated backups (Bonus objective)



\### Cleanup



To destroy all resources:



```bash

\# Delete Kubernetes resources first

kubectl delete -f https://github.com/aws-containers/retail-store-sample-app/releases/latest/download/kubernetes.yaml



\# Wait for LoadBalancer to be deleted (important!)

kubectl get svc --watch



\# Destroy Terraform infrastructure

cd terraform

terraform destroy

```



\*\*⚠️ Warning:\*\* This will delete all resources and cannot be undone.



---



\## Troubleshooting



\### Issue: Pods not starting



```bash

\# Check pod status

kubectl describe pod \[pod-name]



\# Check pod logs

kubectl logs \[pod-name]



\# Check events

kubectl get events --sort-by='.lastTimestamp'

```



\### Issue: Cannot access application



```bash

\# Check service

kubectl get svc ui



\# Check security groups

aws ec2 describe-security-groups --group-ids \[sg-id]



\# Check LoadBalancer

aws elbv2 describe-load-balancers

```



\### Issue: Developer cannot access cluster



```bash

\# Verify aws-auth ConfigMap

kubectl get configmap aws-auth -n kube-system -o yaml



\# Verify RBAC

kubectl get clusterrole readonly-clusterrole

kubectl get clusterrolebinding readonly-clusterrolebinding

```



---



\## Appendix



\### Terraform Outputs



```hcl

vpc\_id = "vpc-00fbb2fed8784a559"

eks\_cluster\_name = "innovatemart-prod-eks"

eks\_cluster\_endpoint = "https://CC1A021C18AA93C220E0CB7E6E2A2A07.gr7.us-east-1.eks.amazonaws.com"

developer\_user\_arn = "arn:aws:iam::861276118104:user/developers/innovatemart-developer"

configure\_kubectl = "aws eks update-kubeconfig --name innovatemart-prod-eks --region us-east-1"

```



\### Useful Commands Reference



```bash

\# Get cluster info

kubectl cluster-info



\# Get all resources

kubectl get all --all-namespaces



\# Export kubeconfig

aws eks update-kubeconfig --name innovatemart-prod-eks --region us-east-1



\# View Terraform state

terraform show



\# Refresh Terraform state

terraform refresh



\# Import existing resource

terraform import \[resource] \[id]

```



---



\*\*Document Version:\*\* 1.0  

\*\*Last Updated:\*\* October 21, 2025  

\*\*Project:\*\* InnovateMart Project Bedrock  

\*\*Author:\*\* Cloud DevOps Team  

\*\*Status:\*\* Production Deployed ✅

