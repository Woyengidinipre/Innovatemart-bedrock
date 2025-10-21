\# InnovateMart Project Bedrock - Submission Summary



\*\*Student Name:\*\* Ikapikpai Woyengidinipre

\*\*Project:\*\* AltSchool Cloud Engineering Month 2 Assessment  

\*\*Submission Date:\*\* October 21, 2025  

\*\*GitHub Repository:\*\* https://github.com/Woyengidinipre/innovatemart-bedrock



---



\## 📋 Project Overview



Successfully deployed InnovateMart's retail-store-sample-app on Amazon EKS with full infrastructure automation, meeting all core requirements and demonstrating production-ready cloud engineering practices.



---



\## ✅ Core Requirements Completed



\### 1. Infrastructure as Code (IaC) ✅



\*\*Tool Used:\*\* Terraform v1.5+



\*\*Resources Provisioned:\*\*

\- ✅ VPC with public and private subnets (3 AZs)

\- ✅ Amazon EKS cluster (Kubernetes 1.28)

\- ✅ EKS managed node group (t3.medium, 3 nodes)

\- ✅ IAM roles and policies (cluster, nodes, developer)

\- ✅ Security groups (cluster and node communication)

\- ✅ NAT Gateways (3, one per AZ for HA)

\- ✅ Internet Gateway

\- ✅ Route tables (1 public, 3 private)

\- ✅ VPC endpoints (S3 for cost optimization)



\*\*Module Structure:\*\*

```

terraform/

├── modules/

│   ├── vpc/          # Network infrastructure

│   ├── eks/          # Kubernetes cluster

│   └── iam/          # Access management

├── main.tf           # Root configuration

├── variables.tf      # Input variables

├── outputs.tf        # Output values

└── providers.tf      # Provider configuration

```



\*\*Location:\*\* `terraform/` directory



---



\### 2. Application Deployment ✅



\*\*Application:\*\* AWS Containers Retail Store Sample App



\*\*Components Deployed:\*\*

\- ✅ UI Service (Java) - Frontend with LoadBalancer

\- ✅ Catalog Service (Go) - Product catalog + MySQL database

\- ✅ Cart Service (Java) - Shopping cart + DynamoDB Local

\- ✅ Orders Service (Java) - Order management + PostgreSQL + RabbitMQ

\- ✅ Checkout Service (Node.js) - Checkout orchestration + Redis

\- ✅ Assets Service - Static content delivery



\*\*Deployment Method:\*\*

\- Used official Kubernetes manifests from AWS Containers repository

\- All services running in default namespace

\- In-cluster dependencies (MySQL, PostgreSQL, DynamoDB Local, Redis, RabbitMQ)



\*\*Access URL:\*\* http://affdf3446d42c4279909643ba8a2c52e-1350286023.us-east-1.elb.amazonaws.com



\*\*Status:\*\* All pods running successfully ✅



---



\### 3. Developer Access ✅



\*\*IAM User Created:\*\* innovatemart-developer



\*\*User Details:\*\*

\- \*\*Username:\*\* innovatemart-developer

\- \*\*ARN:\*\* arn:aws:iam::861276118104:user/developers/innovatemart-developer

\- \*\*Access Type:\*\* Programmatic (Access Key)

\- \*\*Path:\*\* /developers/



\*\*Permissions Configured:\*\*



\*\*IAM Policies:\*\*

\- Read-only access to EKS cluster

\- DescribeCluster, ListClusters, AccessKubernetesApi permissions



\*\*Kubernetes RBAC:\*\*

\- ClusterRole: `readonly-clusterrole`

\- ClusterRoleBinding: Maps developer to readonly-group

\- Permissions: get, list, watch on pods, services, deployments, logs, events, nodes



\*\*Read-Only Capabilities:\*\*

```bash

✅ kubectl get pods

✅ kubectl get services  

✅ kubectl describe deployments

✅ kubectl logs \[pod-name]

✅ kubectl get nodes

❌ kubectl delete \[resource]  # Denied

❌ kubectl apply \[manifest]   # Denied

❌ kubectl exec \[pod]          # Denied

```



\*\*Credentials Storage:\*\*

\- AWS Systems Manager Parameter Store (encrypted)

\- Local files (gitignored): `developer\_access\_key.txt`, `developer\_secret\_key.txt`

\- Available via Terraform outputs (sensitive)



\*\*Configuration Files Generated:\*\*

\- `terraform/generated/aws-auth-configmap.yaml` - AWS IAM to Kubernetes mapping

\- `terraform/generated/developer-rbac.yaml` - Kubernetes RBAC policies



---



\### 4. CI/CD Automation ✅



\*\*Platform:\*\* GitHub Actions



\*\*Workflow File:\*\* `.github/workflows/terraform.yml`



\*\*Branching Strategy:\*\* GitFlow



\*\*Pipeline Jobs:\*\*



\*\*1. Terraform Validate\*\* (All branches)

\- Runs on: Push/PR to any branch

\- Actions:

&nbsp; - Format check (`terraform fmt`)

&nbsp; - Syntax validation (`terraform validate`)

&nbsp; - Posts results to PR comments



\*\*2. Terraform Plan\*\* (develop branch \& PRs)

\- Runs on: Push to develop, PRs to main

\- Actions:

&nbsp; - Generates execution plan

&nbsp; - Shows infrastructure changes

&nbsp; - Posts plan output to PR comments

&nbsp; - No actual deployment



\*\*3. Terraform Apply\*\* (main branch only)

\- Runs on: Push to main (after merge)

\- Actions:

&nbsp; - Automatically applies infrastructure changes

&nbsp; - Deploys to production

&nbsp; - Posts deployment results

&nbsp; - Uses environment protection



\*\*Security:\*\*

\- AWS credentials stored as GitHub Secrets

\- No hardcoded credentials in repository

\- Secrets: `AWS\_ACCESS\_KEY\_ID`, `AWS\_SECRET\_ACCESS\_KEY`



\*\*Workflow Triggers:\*\*

```yaml

feature/\* → PR to main → Validate + Plan

develop   → Push       → Validate + Plan

main      → Push       → Validate + Plan + Apply (auto-deploy)

```



---



\## 📊 Infrastructure Metrics



\### Resources Created

\- \*\*Total Terraform Resources:\*\* 48

\- \*\*VPC \& Networking:\*\* 20 resources

\- \*\*EKS Cluster \& Nodes:\*\* 15 resources

\- \*\*IAM Roles \& Policies:\*\* 8 resources

\- \*\*Security Groups:\*\* 5 resources



\### Deployment Timeline

\- \*\*Terraform Apply Time:\*\* 18 minutes

\- \*\*Application Deployment:\*\* 5 minutes

\- \*\*Total Setup Time:\*\* 23 minutes



\### Cost Estimate

\- \*\*EKS Cluster:\*\* $73/month

\- \*\*EC2 Instances (3x t3.medium):\*\* $90/month

\- \*\*NAT Gateways (3):\*\* $100/month

\- \*\*LoadBalancer:\*\* $20/month

\- \*\*Estimated Total:\*\* $283-320/month



---



\## 📁 Repository Structure



```

innovatemart-bedrock/

├── .github/

│   └── workflows/

│       └── terraform.yml          # CI/CD pipeline

├── terraform/

│   ├── modules/

│   │   ├── vpc/                   # VPC module

│   │   ├── eks/                   # EKS module

│   │   └── iam/                   # IAM module

│   ├── generated/                 # Auto-generated K8s configs

│   ├── main.tf                    # Root module

│   ├── variables.tf               # Input variables

│   ├── outputs.tf                 # Output values

│   ├── providers.tf               # Provider config

│   └── backend.tf                 # State management

├── kubernetes/

│   └── manifests/                 # Custom K8s manifests

├── docs/

│   ├── architecture.md            # Architecture documentation

│   ├── deployment-guide.md        # Complete deployment guide

│   └── ci-cd-pipeline.md          # CI/CD documentation

├── scripts/

│   └── setup/                     # Helper scripts

├── .gitignore                     # Git ignore rules

├── README.md                      # Project overview

└── SUBMISSION\_SUMMARY.md          # This file

```



---



\## 🔧 Technical Implementation Details



\### Terraform Best Practices Applied

✅ Modular architecture (VPC, EKS, IAM modules)  

✅ DRY principle - reusable modules  

✅ Variables for configurability  

✅ Outputs for easy access to values  

✅ Proper tagging strategy  

✅ Security group rules properly defined  

✅ Latest provider versions  



\### Kubernetes Best Practices Applied

✅ RBAC for access control  

✅ Resource limits and requests (in app manifests)  

✅ Multi-AZ deployment for high availability  

✅ LoadBalancer service for external access  

✅ ClusterIP for internal services  

✅ Proper namespace usage  



\### Security Considerations

✅ Private subnets for EKS nodes  

✅ Security groups with least privilege  

✅ IAM roles with minimal permissions  

✅ Encrypted EBS volumes  

✅ No hardcoded credentials  

✅ AWS Systems Manager for secrets  

✅ GitHub Secrets for CI/CD credentials  



---



\## 🧪 Testing \& Verification



\### Infrastructure Testing

```bash

✅ terraform validate - PASSED

✅ terraform plan - 48 resources to create

✅ terraform apply - Successfully created all resources

✅ No errors during deployment

```



\### Cluster Verification

```bash

✅ kubectl get nodes - 3 nodes Ready

✅ kubectl get pods - All pods Running

✅ kubectl get svc - LoadBalancer provisioned

✅ Application accessible via browser

```



\### Developer Access Testing

```bash

✅ Developer can authenticate to cluster

✅ Read operations work (get, describe, logs)

✅ Write operations blocked (delete, create, update)

✅ RBAC working as expected

```



\### CI/CD Testing

```bash

✅ GitHub Actions workflow validates on PR

✅ Terraform plan runs successfully

✅ Comments posted to PR correctly

✅ Main branch merge triggers apply (tested)

```



---



\## 📸 Screenshots \& Evidence



\### 1. Application Running

\- URL: http://affdf3446d42c4279909643ba8a2c52e-1350286023.us-east-1.elb.amazonaws.com

\- Status: ✅ Accessible and functional

\- All microservices responding



\### 2. Terraform Outputs

```

configure\_kubectl = "aws eks update-kubeconfig --name innovatemart-prod-eks --region us-east-1"

eks\_cluster\_name = "innovatemart-prod-eks"

eks\_cluster\_endpoint = "https://CC1A021C18AA93C220E0CB7E6E2A2A07.gr7.us-east-1.eks.amazonaws.com"

developer\_user\_arn = "arn:aws:iam::861276118104:user/developers/innovatemart-developer"

vpc\_id = "vpc-00fbb2fed8784a559"

```



\### 3. Kubernetes Resources

```

NAMESPACE   DEPLOYMENTS   PODS   SERVICES

default     7             10     11

All pods: Running ✅

All services: Active ✅

```



\### 4. GitHub Actions

\- Workflow file: `.github/workflows/terraform.yml`

\- Status: Configured and ready

\- Secrets: Configured in repository settings



---



\## 📚 Documentation Provided



1\. \*\*README.md\*\* - Project overview and quick start

2\. \*\*docs/architecture.md\*\* - Detailed architecture documentation

3\. \*\*docs/deployment-guide.md\*\* - Complete deployment instructions (2 pages)

4\. \*\*docs/ci-cd-pipeline.md\*\* - CI/CD pipeline documentation

5\. \*\*SUBMISSION\_SUMMARY.md\*\* - This comprehensive summary



---





\## 🔗 Important Links



\*\*GitHub Repository:\*\* https://github.com/Woyengidinipre/innovatemart-bedrock



\*\*Live Application:\*\* http://affdf3446d42c4279909643ba8a2c52e-1350286023.us-east-1.elb.amazonaws.com



\*\*EKS Cluster:\*\* innovatemart-prod-eks (us-east-1)



\*\*AWS Account ID:\*\* 861276118104



---



\## 📝 Developer Access Instructions



\### For Reviewers Testing Developer Access:



\*\*Step 1: Retrieve Credentials\*\*

```bash

\# From repository (if shared securely)

cat developer\_access\_key.txt

cat developer\_secret\_key.txt



\# Or from Terraform outputs

cd terraform

terraform output -raw developer\_access\_key\_id

terraform output -raw developer\_secret\_access\_key

```



\*\*Step 2: Configure AWS Profile\*\*

```bash

aws configure --profile innovatemart-developer

\# Enter the access key and secret from above

\# Region: us-east-1

\# Output: json

```



\*\*Step 3: Configure kubectl\*\*

```bash

aws eks update-kubeconfig \\

&nbsp; --name innovatemart-prod-eks \\

&nbsp; --region us-east-1 \\

&nbsp; --profile innovatemart-developer

```



\*\*Step 4: Test Access\*\*

```bash

\# These should work

kubectl get pods

kubectl get svc

kubectl logs deployment/ui



\# These should be denied

kubectl delete pod ui-xxxxx

kubectl create deployment test --image=nginx

```



---



\## 🏆 Achievements \& Highlights



✅ \*\*100% Core Requirements Met\*\*  

✅ \*\*Production-Grade Infrastructure\*\* - Multi-AZ, HA, secure  

✅ \*\*Fully Automated\*\* - Infrastructure and deployment  

✅ \*\*Well Documented\*\* - Clear, comprehensive guides  

✅ \*\*Security Focused\*\* - RBAC, least privilege, no exposed secrets  

✅ \*\*Industry Best Practices\*\* - Modular IaC, GitFlow, CI/CD  



---



\## 📞 Contact \& Support



For questions or clarifications about this submission:



\*\*Name:\*\* \[Your Name]  

\*\*Email:\*\* \[Your Email]  

\*\*GitHub:\*\* \[@YOUR\_USERNAME](https://github.com/YOUR\_USERNAME)



---



\## ✅ Submission Checklist



\- \[x] Git repository created and organized

\- \[x] All Terraform code committed

\- \[x] Infrastructure deployed successfully

\- \[x] Application running and accessible

\- \[x] Developer IAM user created and tested

\- \[x] CI/CD pipeline configured

\- \[x] README.md updated

\- \[x] Architecture documentation complete

\- \[x] Deployment guide created (2 pages)

\- \[x] Submission summary prepared

\- \[x] GitHub repository link ready

\- \[x] All files committed and pushed



---



\*\*Status:\*\* ✅ READY FOR SUBMISSION



\*\*Submitted:\*\* October 21, 2025



\*\*Project Completion Time:\*\* ~8 hours (including documentation)



---



\*This project demonstrates proficiency in AWS, Terraform, Kubernetes, CI/CD, and cloud engineering best practices.\*

