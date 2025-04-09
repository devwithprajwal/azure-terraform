output "acr_name" {
  description = "The name of the Azure Container Registry"
  value       = azurerm_container_registry.acr.name
}

output "key_vault_name" {
  description = "The name of the Azure Key Vault"
  value       = azurerm_key_vault.kv.name
}

output "managed_identity_id" {
  description = "The ID of the Managed Identity"
  value       = azurerm_user_assigned_identity.identity.id
}
