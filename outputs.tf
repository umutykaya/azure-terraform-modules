output "resource_group_name" {
  description = "Name of the deployed Resource Group."
  value       = azurerm_resource_group.this.name
}

output "resource_group_id" {
  description = "Resource ID of the deployed Resource Group."
  value       = azurerm_resource_group.this.id
}

output "key_vault_name" {
  description = "Name of the deployed Key Vault."
  value       = module.key_vault.name
}

output "key_vault_id" {
  description = "Azure Resource ID of the Key Vault."
  value       = module.key_vault.resource_id
}

output "key_vault_uri" {
  description = "URI to access secrets/keys in the Key Vault."
  value       = module.key_vault.uri
}