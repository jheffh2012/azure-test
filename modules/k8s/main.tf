resource "azurerm_user_assigned_identity" "app" {
  name                = "cluster-app-identity"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.aks_cluster_name}-dns"
  depends_on          = [azurerm_user_assigned_identity.app]

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2ms"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app.id]
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
    tenant_id          = var.tenant_id
  }

  network_profile {
    network_plugin = "azure"
  }
}

output "kubeconfig" {
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
  description = "Kubeconfig para usar com kubectl"
}

output "csi_client_id" {
  value       = azurerm_kubernetes_cluster.main.key_vault_secrets_provider[0].secret_identity[0].client_id
  sensitive   = false
  description = "Client ID do Key Vault Secrets Provider"
}

output "csi_object_id" {
  value       = azurerm_kubernetes_cluster.main.key_vault_secrets_provider[0].secret_identity[0].object_id
  sensitive   = false
  description = "Object ID do Key Vault Secrets Provider"
}