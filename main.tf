terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-rg"
    storage_account_name = "terraformvnetpractice"
    container_name       = "tfcontainer"
    key                  = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "~>3.0"

    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.resource_tags
}

module "log_analytics_workspaces" {
  depends_on                 = [azurerm_resource_group.rg]
  source                     = "./modules/log_analytics_workspace"
  log_analytics_workspace_rg = azurerm_resource_group.rg.name
  environment                = var.environment
  log_analytics_workspaces   = var.log_analytics_workspaces
}


module "virtual_networks" {
  depends_on = [
    azurerm_resource_group.rg,
    module.log_analytics_workspaces.log_analytics_workspaces,
  ]
  source                      = "./modules/virtual_network"
  virtual_network_rg          = azurerm_resource_group.rg.name
  environment                 = var.environment
  route_tables                = var.route_tables
  virtual_networks            = var.virtual_networks
  virtual_network_peerings    = var.virtual_network_peerings
  subnets                     = var.subnets
  route_table_association     = var.route_table_association
  log_analytics_workspace     = module.log_analytics_workspaces.log_analytics_workspaces
  monitor_diagnostic_settings = var.vnet_monitor_diagnostic_settings
}


