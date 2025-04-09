resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.azurerm_container_registry_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false
}

# Azure Key Vault
resource "azurerm_key_vault" "kv" {
  name                        = var.azurerm_key_vault_name
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  sku_name                    = "standard"
  tenant_id                   = var.tenant_id
  purge_protection_enabled    = false
  soft_delete_retention_days  = 7
}

# Managed Identity
resource "azurerm_user_assigned_identity" "identity" {
  name                = var.azurerm_user_assigned_identity_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# Assign the Managed Identity to Key Vault with Key, Secret, and Certificate Permissions
resource "azurerm_key_vault_access_policy" "identity_policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = azurerm_user_assigned_identity.identity.tenant_id
  object_id    = azurerm_user_assigned_identity.identity.principal_id

  key_permissions = [
    "Get", "List", "Create", "Delete", "Update", "Import", "Backup", "Restore", "Recover"
  ]

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
  ]

  certificate_permissions = [
    "Get", "List", "Create", "Delete", "Update", "Import", "Backup", "Restore", "Recover"
  ]
}
