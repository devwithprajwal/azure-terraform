##  Terraform AWS Deployment via GitHub Actions

This repository uses **GitHub Actions** to automatically deploy infrastructure on **AWS using Terraform**.

---

###  Workflow Summary

- Sets up Terraform to manage cloud resources safely using an S3 bucket

- Logs in to AWS using secret keys saved in GitHub

- Automatically stores an secret value in secret manager and statefile in S3 bucket

- Runs every time you push or make a pull request to the main branch

---

### Workflow :

1. This triggers the workflow whenever a push is made to the main branch, enabling continuous integration and deployment.
   
```yaml
on:
  push:
    branches:
      - main
```
2. Defines a job named terraform that runs on the latest Ubuntu runner.

```yaml
jobs:
  terraform:
    runs-on: ubuntu-latest
```
3. Defines reusable environment variables for your Azure resource group and AKS cluster.

```yaml
env:
      RESOURCE_GROUP_NAME: abc-rg
      AKS_CLUSTER_NAME: akscluster
```
4. Clones the GitHub repo into the runner to access Terraform files.

```yaml
steps:
      - name: Checkout repository
        uses: actions/checkout@v2
```
5. Configure AWS Credentials
   - Sets up AWS credentials using **GitHub Secrets**.
   - Required to authenticate Terraform against AWS for resource creation.
```yaml
- name: Configure AWS Credentials
      if: env.AWS_ROLE_ARN == ''
      uses: aws-actions/configure-aws-credentials@v3
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1
```
6. Installs Terraform CLI version 1.0.11 in the runner.

```yaml
- name: Set up Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: 1.0.11
```
7. Run Terraform Commands
   - **terraform init**: Initializes Terraform and downloads the required provider plugins.
   - **terraform plan**: Shows what Terraform will do, injecting the secret_value from GitHub Secrets.
   - **terraform apply**: Provisions the infrastructure automatically, including:
     - Storing the .tfstate file in the S3 backend.
     - Creating a secret in AWS Secrets Manager with the value from SECRET_VALUE.

```yaml
- name: terraform
      run: |
          terraform init
          terraform plan -var secret_value="${{ secrets.SECRET_VALUE }}"
          terraform apply -var secret_value="${{ secrets.SECRET_VALUE }}" -auto-approve
```
