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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_monitor_diagnostic_settings"></a> [monitor\_diagnostic\_settings](#module\_monitor\_diagnostic\_settings) | ../monitor_diagnostic_settings | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_network_ddos_protection_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_ddos_protection_plan) | resource |
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_route_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_peering.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_network_ddos_protection_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_ddos_protection_plan) | data source |
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_security_group) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_route_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/route_table) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ddos_protection_plans"></a> [ddos\_protection\_plans](#input\_ddos\_protection\_plans) | DDoS Protection plans to create with their configuration | `any` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Current environment | `string` | n/a | yes |
| <a name="input_existing_ddos_protection_plans"></a> [existing\_ddos\_protection\_plans](#input\_existing\_ddos\_protection\_plans) | Existing DDoS Protection Plans in a List with Name and Resource Group | `any` | `{}` | no |
| <a name="input_existing_network_security_groups"></a> [existing\_network\_security\_groups](#input\_existing\_network\_security\_groups) | Existing Network Security Groups in a List with Name and Resource Group | `any` | `{}` | no |
| <a name="input_existing_route_tables"></a> [existing\_route\_tables](#input\_existing\_route\_tables) | Existing Network Security Groups in a List with Name and Resource Group | `any` | `{}` | no |
| <a name="input_log_analytics_workspace"></a> [log\_analytics\_workspace](#input\_log\_analytics\_workspace) | The Log Analytics Workspaces with their properties. | `any` | n/a | yes |
| <a name="input_monitor_diagnostic_settings"></a> [monitor\_diagnostic\_settings](#input\_monitor\_diagnostic\_settings) | The Monitor Diagnostic Settings with their properties. | `any` | n/a | yes |
| <a name="input_network_security_group_association"></a> [network\_security\_group\_association](#input\_network\_security\_group\_association) | Network Security Group to Subnet | `any` | `{}` | no |
| <a name="input_network_security_groups"></a> [network\_security\_groups](#input\_network\_security\_groups) | Netowrk Security Groups to create with their configuration | `any` | `{}` | no |
| <a name="input_null_array"></a> [null\_array](#input\_null\_array) | - - Other - | `list` | `[]` | no |
| <a name="input_route_table_association"></a> [route\_table\_association](#input\_route\_table\_association) | Route Table Association to Subnet | `any` | `{}` | no |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | Route Tables to create with their configurations | `any` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets to create with their configurations | `any` | `{}` | no |
| <a name="input_virtual_network_peerings"></a> [virtual\_network\_peerings](#input\_virtual\_network\_peerings) | Virtual Network Peering to create with their configurations | `any` | `{}` | no |
| <a name="input_virtual_network_rg"></a> [virtual\_network\_rg](#input\_virtual\_network\_rg) | The Virtual Network resources group name. | `string` | n/a | yes |
| <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks) | Virtual Networks to create with their configurations | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_security_groups"></a> [network\_security\_groups](#output\_network\_security\_groups) | Map output of the Network Security Groups |
| <a name="output_route_tables"></a> [route\_tables](#output\_route\_tables) | Map output of the Route Tables |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Map output of the Subnets |
| <a name="output_virtual_networks"></a> [virtual\_networks](#output\_virtual\_networks) | Map output of the Virtual Networks |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->