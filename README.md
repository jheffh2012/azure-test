# Setup guide after fork

Welcome! To run the Terraform workflows in this fork, follow the instructions:

## 1. Create secrets in your fork

Go to:

`Settings` > `Secrets and variables` > `Actions`

Create the following secrets (example values):

| Name                   | Example value                   |
|------------------------|---------------------------------|
| AZURE_CLIENT_ID        | your service principal client id |
| AZURE_CLIENT_SECRET    | your service principal secret    |
| AZURE_SUBSCRIPTION_ID  | your subscription id            |
| AZURE_TENANT_ID        | your tenant id                  |
| TF_ENVIRONMENT_DEV     | dev                             |
| TF_ENVIRONMENT_PROD    | prod                            |
| TF_BACKEND_KEY_DEV     | dev/terraform.tfstate           |
| TF_BACKEND_KEY_PROD    | prod/terraform.tfstate          |
| TF_BACKEND_RG          | backend resource group name      |
| TF_BACKEND_STORAGE     | storage account name            |
| TF_BACKEND_CONTAINER   | container name                  |

## 2. Run deploy workflow

- Go to **Actions** > **Terraform Deploy**
- Click **Run workflow**
- Choose the branch (`main` for production, `dev` for development)
- The workflow will use the correct secrets and apply the changes automatically

## 3. Run destroy workflow

- Go to **Actions** > **Terraform Destroy**
- Click **Run workflow**
- Choose the branch to set the environment (`main` or `dev`)
- The workflow will destroy the resources for the corresponding environment

---

## 4. Run locally

### Prerequisites

- Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Set up [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) and log in (`az login`)

### Steps

1. Export the environment variables (example for dev environment):

```bash
export ARM_CLIENT_ID=""
export ARM_CLIENT_SECRET=""
export ARM_SUBSCRIPTION_ID=""
export ARM_TENANT_ID=""

export TF_VAR_environment="dev"

export TF_BACKEND_RG="tr"
export TF_BACKEND_STORAGE=""
export TF_BACKEND_CONTAINER=""
export TF_BACKEND_KEY="terraform/terraform.tfstate"
```

2. Initialize Terraform:

```bash
terraform init \
  -backend-config="resource_group_name=$TF_BACKEND_RG" \
  -backend-config="storage_account_name=$TF_BACKEND_STORAGE" \
  -backend-config="container_name=$TF_BACKEND_CONTAINER" \
  -backend-config="key=$TF_BACKEND_KEY"
```

3. Run the plan:

```bash
terraform plan -out=tfplan
```

4. Apply the changes:

```bash
terraform apply tfplan
```

5. (Optional) To destroy the environment:

```bash
terraform destroy -auto-approve
```

6. Next steps

- Add tests in the environment:
    - Terratest;
    - Checkov;
    - InSpec;