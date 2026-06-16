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