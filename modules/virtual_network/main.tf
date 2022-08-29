/*
    Azure Virtual Network Module
      
    Loads
      - Resource Group          - Default Resource Group for Resources
      - DDoS Plans              - Existing DDoS plans
      - Network Security Groups - Existing Network Security Groups
      - User Defined Routes     - Existing User Defined Routes
      - Log Analytics Worspaces - Existing Log Analytics Workspaces

    Resources
      - DDos Plans
      - Virtual Networks
      - Virtual Network Peering
      - Subnets
      - User Defined Routes
      - Network Security Groups
      - Monitor Diagnostic Settings

    Output
      - azurerm_virtual_network.this
      - azurerm_network_ddos_protection_plan.this
      - azurerm_azurerm_network_security_group.this
      - azurerm_route_table.this

    Naming Standards (https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
      - Virtual Network             - vnet-<workload/application>-<environment>-<region>-<###>
      - Subnet                      - snet-<workload/application>-<environment>-<region>-<###>
      - Network Security Group      - nsg-<policy name or app name>-<environment>-<region>-<###>
      - Route Table                 - route-<route table name>
      - DDoS Plan                   - ddos-<environment>-<region>-<###>
      - Monitor Diagnostic Settings - mds-<workload/application>-<environment>-<region>
*/

// -
// - Data gathering
// -

# -
# - Load Resource Group
# - 
data "azurerm_resource_group" "this" {
  name = var.virtual_network_rg
}

# -
# - Load DDoS Plans
# -
data "azurerm_network_ddos_protection_plan" "this" {
  for_each            = var.existing_ddos_protection_plans
  name                = each.value["name"]
  resource_group_name = each.value["resource_group_name"]
}

# -
# - Load Network Security Groups
# -
data "azurerm_network_security_group" "this" {
  for_each            = var.existing_network_security_groups
  name                = each.value["name"]
  resource_group_name = each.value["resource_group_name"]
}

# -
# - Load User Defined Routes
# -
data "azurerm_route_table" "this" {
  for_each            = var.existing_route_tables
  name                = each.value["name"]
  resource_group_name = each.value["resource_group_name"]
}

# -
# - Load Log Analytic Workspace
# -
data "azurerm_log_analytics_workspace" "this" {
  for_each            = var.log_analytics_workspace
  name                = each.value["name"]
  resource_group_name = each.value["resource_group_name"]
}

// -
// - Resources
// -

# -
# - DDoS Plan
# -
resource "azurerm_network_ddos_protection_plan" "this" {
  for_each            = var.ddos_protection_plans
  name                = "ddos-${var.environment}-${lookup(each.value, "location", null) == null ? data.azurerm_resource_group.this.location : each.value["location"]}-${each.value["instance"]}"
  location            = lookup(each.value, "location", null) == null ? data.azurerm_resource_group.this.location : each.value["location"]
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = merge(data.azurerm_resource_group.this.tags, lookup(each.value, "tags", {}))
}

# -
# - Virtual Network
# -
resource "azurerm_virtual_network" "this" {
  depends_on          = [azurerm_network_ddos_protection_plan.this]
  for_each            = var.virtual_networks
  name                = "vnet-${each.value["name"]}-${var.environment}-${lookup(each.value, "location", null) == null ? data.azurerm_resource_group.this.location : each.value["location"]}-${each.value["instance"]}"
  location            = lookup(each.value, "location", null) == null ? data.azurerm_resource_group.this.location : each.value["location"]
  resource_group_name = data.azurerm_resource_group.this.name
  address_space       = each.value["address_space"] #(Required) The address space that is used the virtual network. You can supply more than one address space.

  bgp_community = lookup(each.value, "bgp_community", null) #(Optional) The BGP community attribute in format <as-number>:<community-value>.
  dns_servers   = lookup(each.value, "dns_servers", null)   #(Optional) List of IP addresses of DNS servers
  tags          = merge(data.azurerm_resource_group.this.tags, lookup(each.value, "tags", {}))

  dynamic "ddos_protection_plan" { #(Optional) A ddos_protection_plan block as documented below.
    for_each = lookup(each.value, "ddos_protection_plan", [])
    content {
      id     = lookup(merge(data.azurerm_network_ddos_protection_plan.this, azurerm_network_ddos_protection_plan.this), ddos_protection_plan.value["ddos_protection_plan_key"])["id"] #(Required) The ID of DDoS Protection Plan.
      enable = ddos_protection_plan.value["enable"]                                                                                                                                   #(Required) Enable/disable DDoS Protection Plan on Virtual Network.      
    }
  }
}

# -
# - Virtual Network Peering
# -
resource "azurerm_virtual_network_peering" "this" {
  depends_on                = [azurerm_virtual_network.this]
  for_each                  = var.virtual_network_peerings
  name                      = "vnet-peering-${each.value["name"]}"
  resource_group_name       = data.azurerm_resource_group.this.name
  virtual_network_name      = lookup(azurerm_virtual_network.this, each.value["vnet_key"])["name"] #(Required) The name of the virtual network. Changing this forces a new resource to be created.
  remote_virtual_network_id = each.value["remote_virtual_network_id"]                              #(Required) The full Azure resource ID of the remote virtual network. Changing this forces a new resource to be created.

  allow_virtual_network_access = lookup(each.value, "allow_virtual_network_access", null) #(Optional) Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to true.
  allow_forwarded_traffic      = lookup(each.value, "allow_forwarded_traffic", null)      #(Optional) Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false.
  allow_gateway_transit        = lookup(each.value, "allow_gateway_transit", null)        #(Optional) Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network.
  use_remote_gateways          = lookup(each.value, "use_remote_gateways", null)          #(Optional) Controls if remote gateways can be used on the local virtual network. If the flag is set to true, and allow_gateway_transit on the remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Defaults to false  
}

# - 
# - Subnets
# - 
resource "azurerm_subnet" "this" {
  depends_on           = [azurerm_virtual_network.this]
  for_each             = var.subnets
  name                 = lookup(each.value, "override_name", false) ? each.value["name"] : "snet-${each.value["name"]}-${var.environment}-${lookup(each.value, "location", null) == null ? data.azurerm_resource_group.this.location : each.value["location"]}-${each.value["instance"]}"
  resource_group_name  = data.azurerm_resource_group.this.name
  virtual_network_name = lookup(azurerm_virtual_network.this, each.value["vnet_key"])["name"] #(Required) The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created.

  address_prefixes                               = lookup(each.value, "address_prefixes", null)                               #(Optional) The address prefixes to use for the subnet.
  enforce_private_link_endpoint_network_policies = lookup(each.value, "enforce_private_link_endpoint_network_policies", null) #(Optional) Enable or Disable network policies for the private link endpoint on the subnet. Default value is false. Conflicts with enforce_private_link_service_network_policies.  
  enforce_private_link_service_network_policies  = lookup(each.value, "enforce_private_link_service_network_policies", null)  #(Optional) Enable or Disable network policies for the private link service on the subnet. Default valule is false. Conflicts with enforce_private_link_endpoint_network_policies.  
  service_endpoints                              = lookup(each.value, "service_endpoints", null)                              #(Optional) The list of Service endpoints to associate with the subnet. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage and Microsoft.Web.  
  service_endpoint_policy_ids                    = lookup(each.value, "service_endpoint_policy_ids", null)                    #(Optional) The list of IDs of Service Endpoint Policies to associate with the subnet.  

  dynamic "delegation" { #(Optional) One or more delegation blocks as defined below.  
    for_each = lookup(each.value, "delegation", var.null_array)
    content {
      name = delegation.value["name"] #(Required) A name for this delegation.

      dynamic "service_delegation" {
        for_each = delegation.value["service_delegation"]
        content {
          name    = service_delegation.value["name"]                  #(Required) The name of service to delegate to. Possible values include Microsoft.ApiManagement/service, Microsoft.AzureCosmosDB/clusters, Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.Batch/batchAccounts, Microsoft.ContainerInstance/containerGroups, Microsoft.Databricks/workspaces, Microsoft.DBforMySQL/flexibleServers, Microsoft.DBforMySQL/serversv2, Microsoft.DBforPostgreSQL/flexibleServers, Microsoft.DBforPostgreSQL/serversv2, Microsoft.DBforPostgreSQL/singleServers, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Kusto/clusters, Microsoft.Logic/integrationServiceEnvironments, Microsoft.MachineLearningServices/workspaces, Microsoft.Netapp/volumes, Microsoft.Network/managedResolvers, Microsoft.PowerPlatform/vnetaccesslinks, Microsoft.ServiceFabricMesh/networks, Microsoft.Sql/managedInstances, Microsoft.Sql/servers, Microsoft.StreamAnalytics/streamingJobs, Microsoft.Synapse/workspaces, Microsoft.Web/hostingEnvironments, and Microsoft.Web/serverFarms.
          actions = lookup(service_delegation.value, "actions", null) #(Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values include Microsoft.Network/networkinterfaces/*, Microsoft.Network/virtualNetworks/subnets/action, Microsoft.Network/virtualNetworks/subnets/join/action, Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action and Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action.    
        }
      }
    }
  }
}

# -
# - Route Tables
# -
resource "azurerm_route_table" "this" {
  for_each                      = var.route_tables
  name                          = "rt-${each.value["name"]}"
  location                      = lookup(each.value, "location", null) == null ? data.azurerm_resource_group.this.location : each.value["location"]
  resource_group_name           = data.azurerm_resource_group.this.name
  disable_bgp_route_propagation = lookup(each.value, "disable_bgp_route_propagation", null) #(Optional) Boolean flag which controls propagation of routes learned by BGP on that route table. True means disable.

  dynamic "route" {
    for_each = lookup(each.value, "route", null)
    content {
      name                   = route.value["name"]                                 #(Required) The name of the route.
      address_prefix         = route.value["address_prefix"]                       #(Required) The destination CIDR to which the route applies, such as 10.1.0.0/16. Tags such as VirtualNetwork, AzureLoadBalancer or Internet can also be used.
      next_hop_type          = route.value["next_hop_type"]                        #(Required) The type of Azure hop the packet should be sent to. Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None.
      next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null) #(Optional) Contains the IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance.
    }
  }
}

# -
# - Route Table Association
# -
resource "azurerm_subnet_route_table_association" "this" {
  depends_on = [
    azurerm_virtual_network.this,
    azurerm_subnet.this,
    azurerm_route_table.this
  ]
  for_each       = var.route_table_association
  subnet_id      = lookup(azurerm_subnet.this, each.value["subnet_key"])["id"]
  route_table_id = lookup(merge(data.azurerm_route_table.this, azurerm_route_table.this), each.value["route_table_key"])["id"]
}

# -
# - Network Security Group
# - 
resource "azurerm_network_security_group" "this" {
  for_each = var.network_security_groups
  name     = "nsg-${each.value["name"]}-${var.environment}-${lookup(each.value, "location", null) == null ? data.azurerm_resource_group.this.location : each.value["location"]}-${each.value["instance"]}"
  #name                = "${var.environment}-${each.value["name"]}-${each.value["instance"]}-nsg"
  location            = lookup(each.value, "location", null) == null ? data.azurerm_resource_group.this.location : each.value["location"]
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = merge(data.azurerm_resource_group.this.tags, lookup(each.value, "tags", {}))

  dynamic "security_rule" {
    for_each = lookup(each.value, "security_rule", null)
    content {
      name      = "sr-${security_rule.value["name"]}-${var.environment}" #(Required) The name of the security rule.
      protocol  = security_rule.value["protocol"]                        #(Required) Network protocol this rule applies to. Can be Tcp, Udp, Icmp, or * to match all.
      access    = security_rule.value["access"]                          #(Required) Specifies whether network traffic is allowed or denied. Possible values are Allow and Deny.
      priority  = security_rule.value["priority"]                        #(Required) Specifies the priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.
      direction = security_rule.value["direction"]                       #(Required) The direction specifies if rule will be evaluated on incoming or outgoing traffic. Possible values are Inbound and Outbound.

      description                                = lookup(security_rule.value, "description", null)                                #(Optional) A description for this rule. Restricted to 140 characters.      
      source_port_range                          = lookup(security_rule.value, "source_port_range", null)                          #(Optional) Source Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if source_port_ranges is not specified.
      source_port_ranges                         = lookup(security_rule.value, "source_port_ranges", null)                         #(Optional) List of source ports or port ranges. This is required if source_port_range is not specified.
      destination_port_range                     = lookup(security_rule.value, "destination_port_range", null)                     #(Optional) Destination Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if destination_port_ranges is not specified.
      destination_port_ranges                    = lookup(security_rule.value, "destination_port_ranges", null)                    #(Optional) List of destination ports or port ranges. This is required if destination_port_range is not specified.
      source_address_prefix                      = lookup(security_rule.value, "source_address_prefix", null)                      #(Optional) CIDR or source IP range or * to match any IP. Tags such as ‘VirtualNetwork’, ‘AzureLoadBalancer’ and ‘Internet’ can also be used. This is required if source_address_prefixes is not specified.
      source_address_prefixes                    = lookup(security_rule.value, "source_address_prefixes", null)                    #(Optional) List of source address prefixes. Tags may not be used. This is required if source_address_prefix is not specified.
      source_application_security_group_ids      = lookup(security_rule.value, "source_application_security_group_ids", null)      #(Optional) A List of source Application Security Group ID's
      destination_address_prefix                 = lookup(security_rule.value, "destination_address_prefix", null)                 #(Optional) CIDR or destination IP range or * to match any IP. Tags such as ‘VirtualNetwork’, ‘AzureLoadBalancer’ and ‘Internet’ can also be used. This is required if destination_address_prefixes is not specified.
      destination_address_prefixes               = lookup(security_rule.value, "destination_address_prefixes", null)               #(Optional) List of destination address prefixes. Tags may not be used. This is required if destination_address_prefix is not specified.
      destination_application_security_group_ids = lookup(security_rule.value, "destination_application_security_group_ids", null) #(Optional) A List of destination Application Security Group ID's
    }
  }
}

# -
# - Network Security Group Association
# - 
resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = var.network_security_group_association
  subnet_id                 = lookup(azurerm_subnet.this, each.value["subnet_key"])["id"]
  network_security_group_id = lookup(merge(data.azurerm_network_security_group.this, azurerm_network_security_group.this), each.value["nsg_key"])["id"]
}


// -
// - Logging
// -

# -
# - Monitor Diagnostic Settings
# - 
module "monitor_diagnostic_settings" {
  depends_on                 = [azurerm_virtual_network.this]
  source                     = "../monitor_diagnostic_settings"
  for_each                   = var.monitor_diagnostic_settings
  name                       = "mds-${each.value["name"]}-${var.environment}"
  target_resource_id         = lookup(azurerm_virtual_network.this, each.value["resource_key"])["id"]
  log_analytics_workspace_id = lookup(data.azurerm_log_analytics_workspace.this, each.value["log_analytics_workspace_key"])["id"]
  log_block                  = lookup(each.value, "log", null)
  metric_block               = lookup(each.value, "metric", null)
}