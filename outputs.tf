output "resource_group_name" {
  value = module.resource_group.name
}

output "key_vault_name" {
  value = module.key_vault.name
}

output "key_vault_uri" {
  value = module.key_vault.uri
}
