module "key_vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.10.1"

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tenant_id           = var.tenant_id
  sku_name            = var.sku_name

  soft_delete_retention_days    = 7
  purge_protection_enabled      = var.purge_protection_enabled
  public_network_access_enabled = true

  network_acls = {
    bypass         = "AzureServices"
    default_action = "Allow"
    ip_rules       = []
  }

  role_assignments = {
    deployer = {
      role_definition_id_or_name = "Key Vault Administrator"
      principal_id               = var.deployer_object_id
      description                = "Admin access for deploying identity"
    }
  }

  enable_telemetry = false
  tags             = var.tags
}
