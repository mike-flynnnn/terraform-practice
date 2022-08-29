#### Table of Contents
1. [Usage](#usage)
2. [Requirements](#requirements)
3. [Providers](#Providers)
4. [Inputs](#inputs)
5. [Outputs](#outputs)
## Usage
*various commands
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Current environment | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_rg"></a> [log\_analytics\_workspace\_rg](#input\_log\_analytics\_workspace\_rg) | The Log Analytics Workspace resources group name. | `string` | n/a | yes |
| <a name="input_log_analytics_workspaces"></a> [log\_analytics\_workspaces](#input\_log\_analytics\_workspaces) | Log Analytics Workspaces to create with their configuration | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_analytics_workspaces"></a> [log\_analytics\_workspaces](#output\_log\_analytics\_workspaces) | Map output of the Log Analytics Workspaces |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->