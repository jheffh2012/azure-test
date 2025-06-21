variable "environment" {
  description = "Ambiente de implantação (ex: dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Localização dos recursos Azure"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
  default     = "rg-redis-kv-demo"
}

variable "redis_name" {
  description = "Nome do Redis Cache"
  type        = string
  default     = "redis-kv-demo"
}

variable "key_vault_name" {
  description = "Nome do Key Vault"
  type        = string
  default     = "kvredisdemo"
}

variable "aks_cluster_name" {
  description = "Nome do cluster AKS"
  type        = string
  default     = "aks-redis-demo"
}