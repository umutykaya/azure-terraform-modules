# Azure Data Platform Terraform Modules

A collection of reusable Terraform modules for building a modern data platform on Azure, following Azure Verified Modules (AVM) guidelines.

## Overview

This project provides modular Terraform configurations for deploying a comprehensive data platform architecture on Azure, including:

- **Data Lake**: Azure Data Lake Storage Gen2 with hierarchical organization
- **Data Warehouse**: Azure Synapse Analytics workspace
- **Data Factory**: Azure Data Factory for orchestration
- **Monitoring**: Log Analytics and Application Insights

## Architecture

```
┌─────────────────────────────────────────┐
│       Azure Data Platform               │
├─────────────────────────────────────────┤
│  ┌─────────────┐  ┌──────────────────┐  │
│  │ Data Lake   │  │ Data Warehouse   │  │
│  │ (Gen2 ADLS) │  │ (Azure Synapse)  │  │
│  └─────────────┘  └──────────────────┘  │
│        │                    │            │
│        └──────┬─────────────┘            │
│               │                          │
│        ┌──────▼──────────┐              │
│        │  Data Factory   │              │
│        │     (ADF)       │              │
│        └─────────────────┘              │
│               │                          │
│        ┌──────▼──────────┐              │
│        │  Monitoring     │              │
│        │  Log Analytics  │              │
│        └─────────────────┘              │
└─────────────────────────────────────────┘
```

## Project Structure

```
.
├── main.tf                    # Root module definitions
├── variables.tf               # Root variables
├── outputs.tf                 # Root outputs
├── locals.tf                  # Local values and naming conventions
├── versions.tf                # Terraform and provider versions
├── terraform.tf               # Backend configuration
├── modules/
│   ├── data_lake/             # Data Lake module
│   ├── data_warehouse/        # Data Warehouse module
│   ├── data_factory/          # Data Factory module
│   └── monitoring/            # Monitoring module
├── examples/
│   ├── default/               # Basic deployment example
│   └── complete/              # Full deployment example
├── tests/
│   ├── unit/                  # Unit tests
│   └── e2e/                   # End-to-end tests
├── .github/
│   └── workflows/             # CI/CD pipelines
├── .pre-commit-config.yaml    # Pre-commit hooks configuration
├── tflint.hcl                 # TFLint configuration
└── README.md                  # This file
```

## Prerequisites

- Terraform >= 1.3
- Azure CLI configured with appropriate credentials
- Azure subscription
- (Optional) Pre-commit hooks for local linting

## Usage

### Basic Deployment (Dev Environment)

```hcl
module "data_platform" {
  source = "./"

  resource_group_name = "rg-data-platform-dev"
  location            = "eastus"
  environment         = "dev"
  project_name        = "mycompany"

  enable_data_lake      = true
  enable_data_warehouse = false
  enable_data_factory   = false
  enable_monitoring     = true

  tags = {
    Environment = "dev"
  }
}
```

### Complete Deployment (Production)

See [examples/complete/main.tf](./examples/complete/main.tf) for a full production example.

## Module Details

### Data Lake Module
Provisions Azure Data Lake Storage Gen2 with:
- Hierarchical namespace enabled
- Default file systems: raw, processed, curated, archive
- Diagnostic logging to Log Analytics
- HTTPS-only access

**Variables**: `storage_account_sku`, `log_analytics_workspace_id`

### Data Warehouse Module
Provisions Azure Synapse Analytics with:
- Dedicated SQL pool support
- Managed virtual networking
- Firewall rules for Azure services
- Diagnostic logging

**Variables**: `sql_admin_login`, `sql_admin_password`

### Data Factory Module
Provisions Azure Data Factory with:
- System-assigned managed identity
- Diagnostic logging for activity and pipeline runs
- Monitor action group integration

### Monitoring Module
Provisions monitoring infrastructure:
- Log Analytics workspace (retention based on environment)
- Application Insights
- Monitor action group for alerts

## Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `resource_group_name` | string | - | Resource group name |
| `location` | string | - | Azure region |
| `environment` | string | - | Environment (dev/staging/prod) |
| `project_name` | string | - | Project name for naming conventions |
| `enable_data_lake` | bool | true | Enable Data Lake deployment |
| `enable_data_warehouse` | bool | true | Enable Data Warehouse deployment |
| `enable_data_factory` | bool | true | Enable Data Factory deployment |
| `enable_monitoring` | bool | true | Enable monitoring deployment |
| `data_lake_sku` | string | Standard_LRS | Data Lake storage SKU |
| `tags` | map(string) | {} | Tags to apply to resources |

## Outputs

- `resource_group_id` - Resource group ID
- `resource_group_name` - Resource group name
- `data_lake_storage_id` - Data Lake storage account ID
- `data_lake_storage_endpoint` - Data Lake primary blob endpoint
- `data_warehouse_workspace_id` - Synapse workspace ID
- `data_factory_id` - Data Factory ID
- `log_analytics_workspace_id` - Log Analytics workspace ID

## Development

### Setting up Pre-commit Hooks

```bash
pre-commit install
pre-commit run --all-files
```

### Running Terraform Validation Locally

```bash
terraform init
terraform validate
terraform plan -var-file=terraform.tfvars
```

```bash
terraform fmt -recursive
terraform validate
tflint
tfsec
```

### Running Tests

```bash
cd tests/unit
terraform validate

cd ../e2e
terraform validate
```

## CI/CD Pipelines

The project includes automated GitHub Actions workflows:

- **terraform-validate.yml** - Validates Terraform syntax
- **tflint.yml** - Runs TFLint checks
- **tfsec.yml** - Runs security scans
- **terraform-plan.yml** - Plans infrastructure changes

## Security

- All resources use HTTPS-only access
- Storage accounts have public access disabled
- Managed identities for service authentication
- Diagnostic logging enabled by default
- Security scanning via TFSec

## Cost Optimization

- Dev/Staging: LRS replication, 30-day log retention
- Production: GRS replication, 90-day log retention
- Auto-scaling configured for appropriate resources

## Troubleshooting

### Backend Configuration

Update `terraform.tf` with your remote state configuration:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstate"
    container_name       = "tfstate"
    key                  = "data-platform/terraform.tfstate"
  }
}
```

### Authentication

Ensure Azure CLI is authenticated:

```bash
az login
az account set --subscription <subscription-id>
```

## Contributing

1. Create a feature branch
2. Make changes and validate locally
3. Run pre-commit hooks
4. Submit a pull request
5. Ensure CI/CD pipelines pass

## License

MIT License - see LICENSE file for details

## Support

For issues or questions, please create an issue in the repository.

---

**Last Updated**: June 2026
**Terraform Version**: >= 1.3
**Azure Provider**: >= 4.0

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9, < 2.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.4 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.117, < 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.5 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.9 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.77.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_key_vault"></a> [key\_vault](#module\_key\_vault) | ./modules/key_vault | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | ./modules/resource_group | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment for which the data platform resources will be created. | `string` | `"dev"` | no |
| <a name="input_location"></a> [location](#input\_location) | The location of the resource group where the data platform resources will be created. | `string` | `"westus2"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project for which the data platform resources will be created. | `string` | `"mad-platform"` | no |
| <a name="input_purge_protection_enabled"></a> [purge\_protection\_enabled](#input\_purge\_protection\_enabled) | Enable purge protection on Key Vault. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where the data platform resources will be created. | `string` | `"rg-mad-platform"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The subscription ID for the Azure account. | `string` | `"98014c53-83b7-4bfb-a4a4-2e31b0f22465"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags for all resources. | `map(string)` | <pre>{<br/>  "environment": "dev",<br/>  "project": "mad-platform"<br/>}</pre> | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | n/a |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
<!-- END_TF_DOCS -->
