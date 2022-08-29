/*
    Azure Azure Log Analytics Workspace      

    Loads
      - Resource Group - Default Resource Group for Resources

    Resources
      - Log Analytics Workspace

    Output
      - azurerm_log_analytics_workspace.this

    Naming Standards (https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
      - Log Analytics Workspace - law-<workload/application>-<environment>-<region>-<###>

    TODO
      - Virtual Network Isolation
*/

// -
// - Data gathering
// -

# -
# - Load Resource Group
# - 
data "azurerm_resource_group" "this" {
  name = var.log_analytics_workspace_rg
}

// -
// - Resources
// -

# -
# - Log Analytics Workspace
# -
resource "azurerm_log_analytics_workspace" "this" {
  for_each                   = var.log_analytics_workspaces
  name                       = "law-${each.value["name"]}-${var.environment}-${lookup(each.value, "location", null) == null ? data.azurerm_resource_group.this.location : each.value["location"]}-${each.value["instance"]}"
  location                   = lookup(each.value, "location", null) == null ? data.azurerm_resource_group.this.location : each.value["location"] #(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.
  resource_group_name        = data.azurerm_resource_group.this.name                                                                             #(Required) The name of the resource group in which the Log Analytics workspace is created. Changing this forces a new resource to be created.
  sku                        = lookup(each.value, "sku", null)                                                                                   #(Optional) Specifies the Sku of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new Sku as of 2018-04-03). Defaults to PerGB2018.
  retention_in_days          = lookup(each.value, "retention_in_days", null)                                                                     #(Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730.
  daily_quota_gb             = lookup(each.value, "daily_quota_gb", null)                                                                        #(Optional) The workspace daily quota for ingestion in GB. Defaults to -1 (unlimited) if omitted.
  internet_ingestion_enabled = lookup(each.value, "internet_ingestion_enabled", null)                                                            #(Optional) Should the Log Analytics Workflow support ingestion over the Public Internet? Defaults to true.
  internet_query_enabled     = lookup(each.value, "internet_query_enabled", null)                                                                #(Optional) Should the Log Analytics Workflow support querying over the Public Internet? Defaults to true.

  tags = merge(data.azurerm_resource_group.this.tags, lookup(each.value, "tags", null))
}