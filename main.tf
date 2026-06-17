data "azurerm_client_config" "current" {}

module "resource_group" {
  source = "./modules/resource_group"

  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location
  tags     = var.tags
}

module "key_vault" {
  source = "./modules/key_vault"

  name                     = "kv-${var.project_name}-${var.environment}"
  resource_group_name      = module.resource_group.name
  location                 = module.resource_group.location
  tenant_id                = data.azurerm_client_config.current.tenant_id
  deployer_object_id       = data.azurerm_client_config.current.object_id
  purge_protection_enabled = var.purge_protection_enabled
  tags                     = var.tags
}

module "databricks" {
  source = "./modules/databricks_workspace"

  name                = "db-${var.project_name}-${var.environment}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  tags                = var.tags
}
