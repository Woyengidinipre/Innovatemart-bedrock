\# CI/CD Pipeline Documentation



\## Overview

This project uses GitHub Actions to automate Terraform infrastructure deployment following a GitFlow branching strategy.



\## Branching Strategy



\### Main Branch (`main`)

\- \*\*Production environment\*\*

\- Merges to `main` trigger `terraform apply`

\- Automatically deploys infrastructure changes

\- Protected branch (requires PR approval)



\### Develop Branch (`develop`)

\- \*\*Development/staging environment\*\*

\- Pushes trigger `terraform plan` only

\- Used for testing changes before production



\### Feature Branches (`feature/\*`)

\- Pull requests trigger validation and plan

\- No automatic deployment

\- Code review required before merge



\## Workflow Jobs



\### 1. Terraform Validate

\*\*Triggers:\*\* All branches on push/PR

\*\*Purpose:\*\* Ensure Terraform code is properly formatted and valid



\*\*Steps:\*\*

\- Checkout code

\- Setup Terraform

\- Format check (`terraform fmt`)

\- Initialize (`terraform init`)

\- Validate (`terraform validate`)

\- Comment results on PR



\### 2. Terraform Plan

\*\*Triggers:\*\* Pull requests to `main`, pushes to `develop`

\*\*Purpose:\*\* Preview infrastructure changes



\*\*Steps:\*\*

\- Checkout code

\- Configure AWS credentials

\- Setup Terraform

\- Initialize Terraform

\- Run `terraform plan`

\- Post plan output as PR comment



\### 3. Terraform Apply

\*\*Triggers:\*\* Push to `main` branch only

\*\*Purpose:\*\* Deploy infrastructure changes to production



\*\*Steps:\*\*

\- Checkout code

\- Configure AWS credentials

\- Setup Terraform

\- Initialize Terraform

\- Plan infrastructure changes

\- Apply changes automatically

\- Output deployment results



\## Security



\### Secrets Management

The following secrets are required in GitHub repository settings:



| Secret Name | Description |

|------------|-------------|

| `AWS\_ACCESS\_KEY\_ID` | AWS access key for Terraform deployment |

| `AWS\_SECRET\_ACCESS\_KEY` | AWS secret access key for Terraform deployment |



\### Best Practices

\- Never commit AWS credentials to the repository

\- Use least-privilege IAM policies

\- Enable branch protection on `main`

\- Require PR reviews before merging

\- Use environment protection rules



\## Workflow Files



\### Location

`.github/workflows/terraform.yml`



\### Configuration

```yaml

env:

&nbsp; TF\_VERSION: '1.5'

&nbsp; AWS\_REGION: 'us-east-1'

```



\## Usage Examples



\### Making Infrastructure Changes



1\. \*\*Create a feature branch:\*\*

```bash

git checkout -b feature/add-new-resource

```



2\. \*\*Make your changes in `terraform/`\*\*



3\. \*\*Commit and push:\*\*

```bash

git add terraform/

git commit -m "Add new EKS node group"

git push origin feature/add-new-resource

```



4\. \*\*Create Pull Request to `main`:\*\*

&nbsp;  - GitHub Actions will run validation and plan

&nbsp;  - Review the plan in PR comments

&nbsp;  - Get approval from team members



5\. \*\*Merge to `main`:\*\*

&nbsp;  - Automatically triggers `terraform apply`

&nbsp;  - Infrastructure is deployed

&nbsp;  - Check Actions tab for deployment status



\### Emergency Rollback



If deployment fails:



1\. \*\*Revert the commit:\*\*

```bash

git revert <commit-hash>

git push origin main

```



2\. \*\*Or manually fix:\*\*

&nbsp;  - Push a fix to a new branch

&nbsp;  - Create PR with the fix

&nbsp;  - Merge after approval



\## Monitoring



\### Check Workflow Status

\- Go to \*\*Actions\*\* tab in GitHub repository

\- View recent workflow runs

\- Check logs for any failures



\### Notifications

\- Configure GitHub notifications for workflow failures

\- Set up Slack/email integration if needed



\## Troubleshooting



\### Common Issues



\*\*Issue:\*\* `terraform init` fails

\*\*Solution:\*\* Check AWS credentials are configured correctly



\*\*Issue:\*\* `terraform plan` shows unexpected changes

\*\*Solution:\*\* Review state file, ensure no manual changes were made



\*\*Issue:\*\* `terraform apply` fails

\*\*Solution:\*\* Check CloudWatch logs, verify AWS service quotas



\## Future Enhancements



\- \[ ] Add terraform state locking with DynamoDB

\- \[ ] Implement automatic testing before apply

\- \[ ] Add cost estimation in PR comments

\- \[ ] Set up separate AWS accounts for dev/prod

\- \[ ] Implement manual approval gates

\- \[ ] Add security scanning (tfsec, checkov)



---

\*\*Last Updated:\*\* October 2025

\*\*Maintained By:\*\* CloudDevOps Team

