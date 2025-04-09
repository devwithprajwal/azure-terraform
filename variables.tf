variable "resource_group_name" {
  description = "The name of the Azure Resource Group"
  type        = string
  default     = "my-indigopraj-rg"
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = "East US"
}

variable "azurerm_container_registry_name" {
  description = "The name of the Azure Container Registry"
  type        = string
  default     = "indigoprajacr78" 
}

variable "azurerm_key_vault_name" {
  description = "The name of the Azure Key Vault"
  type        = string
  default     = "indigoprajkv45"
  
}

variable "azurerm_user_assigned_identity_name" {
  description = "The name of the Azure User Assigned Identity"
  type        = string
  default     = "indigoprajidentity1"
}
variable "client_id" {}
variable "client_secret" {}
variable "subscription_id" {}
variable "tenant_id" {}
