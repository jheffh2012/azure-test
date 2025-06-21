# Guia de configuração após fork

Bem-vindo! Para rodar os workflows Terraform neste fork, siga as instruções:

## 1. Criar secrets no seu fork

Acesse:

`Settings` > `Secrets and variables` > `Actions`

Crie os seguintes secrets (valores de exemplo):

| Nome                   | Valor exemplo                 |
|------------------------|------------------------------|
| AZURE_CLIENT_ID        | sua service principal client id |
| AZURE_CLIENT_SECRET    | sua service principal secret |
| AZURE_SUBSCRIPTION_ID  | seu subscription id          |
| AZURE_TENANT_ID        | seu tenant id                |
| TF_ENVIRONMENT_DEV     | dev                          |
| TF_ENVIRONMENT_PROD    | prod                         |
| TF_BACKEND_KEY_DEV     | dev/terraform.tfstate        |
| TF_BACKEND_KEY_PROD    | prod/terraform.tfstate       |
| TF_BACKEND_RG          | nome do resource group backend |
| TF_BACKEND_STORAGE     | nome do storage account      |
| TF_BACKEND_CONTAINER   | nome do container            |

## 2. Executar workflow de deploy

- Vá em **Actions** > **Terraform Deploy**
- Clique em **Run workflow**
- Escolha a branch (`main` para produção, `dev` para desenvolvimento)
- O workflow usará os secrets corretos e aplicará as mudanças automaticamente

## 3. Executar workflow de destruição

- Vá em **Actions** > **Terraform Destroy**
- Clique em **Run workflow**
- Escolha a branch para definir o ambiente (`main` ou `dev`)
- O workflow destruirá os recursos do ambiente correspondente

---

## 4. Rodar localmente

### Pré-requisitos

- Instale o [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Configure [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) e faça login (`az login`)

### Passos

1. Exporte as variáveis de ambiente (exemplo para ambiente dev):

```bash
export ARM_CLIENT_ID=""
export ARM_CLIENT_SECRET=""
set ARM_SUBSCRIPTION_ID=""
set ARM_TENANT_ID=""

set TF_VAR_environment="dev"

set TF_BACKEND_RG="tr"
set TF_BACKEND_STORAGE="jrksistemasstates"
set TF_BACKEND_CONTAINER="dev"
set TF_BACKEND_KEY="terraform/terraform.tfstate"
```

2. Inicialize o Terraform:

```bash
terraform init -backend-config="resource_group_name=%TF_BACKEND_RG%" -backend-config="storage_account_name=%TF_BACKEND_STORAGE%"  -backend-config="container_name=%TF_BACKEND_CONTAINER%" -backend-config="key=%TF_BACKEND_KEY%"
```

3. Execute o plano:

```bash
terraform plan -out=tfplan
```

4. Aplique as mudanças:

```bash
terraform apply tfplan
```

5. (Opcional) Para destruir o ambiente::

```bash
terraform destroy -auto-approve
```