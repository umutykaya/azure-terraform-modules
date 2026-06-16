# ─────────────────────────────────────────────
# Data source: current Azure client config
# ─────────────────────────────────────────────
data "azurerm_client_config" "current" {}

# ─────────────────────────────────────────────
# 1) Resource Group (native azurerm resource)
# ─────────────────────────────────────────────
resource "azurerm_resource_group" "this" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location
  tags     = var.tags
}

# ─────────────────────────────────────────────
# 2) Key Vault — AVM module
# ─────────────────────────────────────────────
module "key_vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.10.1"

  # Required inputs
  name                = "kv-${var.project_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tenant_id           = data.azurerm_client_config.current.tenant_id

  # SKU: "standard" or "premium"
  sku_name = "standard"

  # Soft delete & purge protection (recommended for production)
  soft_delete_retention_days = 7
  purge_protection_enabled   = false # Set true for production!

  # Public network access (open for dev; restrict for prod)
  public_network_access_enabled = true

  # Network ACLs — allow all traffic in dev
  network_acls = {
    bypass         = "AzureServices"
    default_action = "Allow"
    ip_rules       = []
  }

  # Grant the deploying identity Key Vault Administrator access via RBAC
  role_assignments = {
    deployer = {
      role_definition_id_or_name = "Key Vault Administrator"
      principal_id               = data.azurerm_client_config.current.object_id
      description                = "Full admin access for the deploying identity"
    }
  }

  # Disable telemetry (optional)
  enable_telemetry = false

  tags = var.tags
}