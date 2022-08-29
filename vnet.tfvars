location            = "East US"
resource_group_name = "rg-network-eastus-001"
environment         = "prod"

resource_tags = {
  "service"     = "Network Hub"
  "environment" = "prod"
  "deployment"  = "terraform"
  "cicd"        = "Azure DevOps"
}

log_analytics_workspaces = {
  NETWORK = {
    name              = "network-hub"
    instance          = "001"
    location          = "eastus"
    retention_in_days = 30

    tags = {
      "workload" = "Network Log Analytics Workspace"
    }
  }
}

virtual_networks = {
  VNET-001 = {
    name          = "network-hub"
    instance      = "001"
    location      = "eastus"
    address_space = ["10.0.0.0/26"] # how to determine appropriate # of IPs? 64 IPs seems high. 
    tags = {
      "workload" = "Virtual Network"
      "peering"  = "hub-to-spoke"
    }
  }
}

network_security_group = {
  name                = "NetworkSecurityGroup"
  location            = var.location
  resource_group_name = var.resource_group_name
}

subnets = {
  PUBLIC = {
    name                 = "PublicSubnet"
    resource_group_name  = var.resource_group_name
    virtual_network_name = var.virtual_networks["VNET-001"].name
    address_prefixes     = ["10.0.1.0/27"]
  }
  PRIVATE = {
    name                 = "PrivateSubnet"
    resource_group_name  = var.resource_group_name
    virtual_network_name = var.virtual_networks["VNET-001"].name
    address_prefixes     = ["10.0.2.0/27"]   # how to determine the address prefixs and CIDR allotment? 
  }
}

subnet_network_security_group_association = {
  PUBLIC = {
    subnet_id                 = var.subnets["PUBLIC"].id
    network_security_group_id = var.network_security_group.id
  }
  PRIVATE = {
    subnet_id                 = var.subnets["PRIVATE"].id
    network_security_group_id = var.network_security_group.id
  }
}

virtual_wan = {
  name                = "VirtualWan"
  resource_group_name = var.resource_group_name
  location            = var.location
}

virtual_hub = {
  name                = "VirtualHub"
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_wan_id      = var.virtual_wan.id
  address_prefix      = "10.0.3.0/23"  # docs recommend 23
}

virtual_hub_connection = {
  name                      = "VirtualHubConnection"
  virtual_hub_id            = var.virtual_hub.id
  remote_virtual_network_id = var.virtual_networks["VNET-001"].id
}

route_tables = {
  VHUB-ROUTE-TABLE = {
    name           = "RouteTable"
    virtual_hub_id = var.virtual_hub.id
    route = {
      name             = "Route"
      destination_type = "CIDR"
      destinations     = ["10.0.0.0/24"]
      next_hop_type    = "ResourceId"
      next_hop         = var.virtual_hub_connection.id
    }
  }
}

private_dns_zone = {
  name                = "testdomain.com"
  resource_group_name = var.resource_group_name
}

private_dns_zone_virtual_network_link = {
  name                  = "PrivateDnsLink"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = var.private_dns_zone.name
  virtual_network_id    = var.virtual_networks["VNET-001"].id
}