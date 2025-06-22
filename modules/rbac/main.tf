resource "azurerm_role_assignment" "kv_rbac_access" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.object_id
}