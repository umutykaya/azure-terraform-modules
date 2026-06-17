# Serverless workspace: compute_mode is creation-only and cannot be changed in place.
module "databricks" {
  source = "Azure/avm-res-databricks-workspace/azurerm"
  version = "0.5.0"

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "premium"
  compute_mode        = "Serverless"
  enable_telemetry    = var.enable_telemetry
}
