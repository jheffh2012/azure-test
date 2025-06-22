provider "azurerm" {
  features {}
  skip_provider_registration = true
}

terraform {
  backend "azurerm" {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

module "redis" {
  source              = "./modules/redis"
  redis_name          = var.redis_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

module "vault" {
  source              = "./modules/vault"
  key_vault_name      = var.key_vault_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

module "k8s" {
  source              = "./modules/k8s"
  aks_cluster_name    = var.aks_cluster_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

module "rbac" {
  source       = "./modules/rbac"
  key_vault_id = module.vault.key_vault_id
  object_id    = module.k8s.csi_object_id
  depends_on   = [module.vault.app, module.k8s.app]
}