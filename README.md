##  Terraform Azure Deployment Pipeline via GitHub Actions

-This repository uses GitHub Actions to run a **CI/CD pipeline** that automates infrastructure deployment using Terraform.

-It sets up **Azure resources** like Resource Group, Container Registry, Key Vault, Managed Identity, and Access Policies.

-**Terraform state file** is stored securely in an existing **Azure Storage Account** inside a **Blob Container** for backend tracking.

-**Azure credentials** (Client ID, Secret, Subscription ID, Tenant ID) are stored securely in **GitHub Secrets** to authenticate with **Azure**.

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
3. Clones the GitHub repo into the runner to access Terraform files.

```yaml
steps:
      - name: Checkout repository
        uses: actions/checkout@v2
```
5. Configure Azure Credentials
   - Sets up Azure credentials using **GitHub Secrets**.
   - Required to authenticate Terraform against Azure for resource creation.
```yaml
- name: Set environment variable's
      run: |
        echo "ARM_CLIENT_ID=${{ secrets.CLIENT_ID }}" >> $GITHUB_ENV
        echo "ARM_CLIENT_SECRET=${{ secrets.CLIENT_SECRET }}" >> $GITHUB_ENV
        echo "ARM_SUBSCRIPTION_ID=${{ secrets.SUBSCRIPTION_ID }}" >> $GITHUB_ENV
        echo "ARM_TENANT_ID=${{ secrets.TENANT_ID }}" >> $GITHUB_ENV
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
   - **terraform plan**: Shows what Terraform will do, injecting the secrets from GitHub Secrets.
   - **terraform apply**: Provisions the infrastructure automatically, including:
     - Storing the .tfstate file in the Azure Storage Account in backend in Blob container.

```yaml
- name: Terraformautomation
      run: |
          terraform init
          terraform plan -var client_id="${{ secrets.CLIENT_ID }}" -var client_secret="${{ secrets.CLIENT_SECRET }}" -var subscription_id="${{ secrets.SUBSCRIPTION_ID }}" -var tenant_id="${{ secrets.TENANT_ID }}"
          terraform apply -var client_id="${{ secrets.CLIENT_ID }}" -var client_secret="${{ secrets.CLIENT_SECRET }}" -var subscription_id="${{ secrets.SUBSCRIPTION_ID }}" -var tenant_id="${{ secrets.TENANT_ID }}" --auto-approve
```
