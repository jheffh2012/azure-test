resource "azurerm_key_vault" "main" {
  name                      = var.key_vault_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  tenant_id                 = var.tenant_id
  sku_name                  = "standard"
  enable_rbac_authorization = true

  # soft_delete_enabled     = true
  # purge_protection_enabled = false
}

output "key_vault_id" {
  value       = azurerm_key_vault.main.id
  sensitive   = false
  description = "ID do Key Vault"
}