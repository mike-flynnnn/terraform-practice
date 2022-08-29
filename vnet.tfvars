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

# What do I create below to activate => resource "azurerm_network_security_group" "this" module?
network_security_group = {
  name = "NetworkSecurityGroup"
  # security_rule = {
  #   name                       = "test123"
  #   priority                   = 100
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "*"
  #   source_address_prefix      = "*"
  #   destination_address_prefix = "*"
  # }
}

subnets = {
  PUBLIC = {
    name                 = "PublicSubnet"
    virtual_network_name = "vnet-key-tbd" # where to get virtual network key?
    address_prefixes     = ["10.0.1.0/27"]
  }
  PRIVATE = {
    name                 = "PrivateSubnet"
    virtual_network_name = "vnet-key-tbd"
    address_prefixes     = ["10.0.2.0/27"] # how to determine the address prefixs and CIDR allotment? 
  }
}

subnet_network_security_group_association = {
  PUBLIC = {
    subnet_id                 = "public-subnet-001"
    network_security_group_id = "nsg-001"
  }
  PRIVATE = {
    subnet_id                 = "private-subnet-001"
    network_security_group_id = "nsg-001"
  }
}

virtual_wan = {
  name     = "VirtualWan"
  location = "eastus"
}

virtual_hub = {
  name           = "VirtualHub"
  location       = "eastus"
  virtual_wan_id = "v-wan-001"
  address_prefix = "10.0.3.0/23" # docs recommend 23
}

virtual_hub_connection = {
  name           = "VirtualHubConnection"
  virtual_hub_id = "v-hub-001"
  # remote_virtual_network_id = var.virtual_networks["VNET-001"].id
  remote_virtual_network_id = "remote-vnet-001" # where do I get these actual values? Should these be created in Azure first?
}

# How to use this to activate => resource "azurerm_route_table" "this"
route_tables = {
  VHUB-ROUTE-TABLE = {
    # name           = "RouteTable"
    virtual_hub_id = "v-hub-001"
    #   route = {
    #     name             = "Route"
    #     destination_type = "CIDR"
    #     destinations     = ["10.0.0.0/24"]
    #     next_hop_type    = "ResourceId"
    #     next_hop         = "v-hub-connection-001"
    #   }
  }
}

private_dns_zone = {
  name = "testdomain.com"
}

private_dns_zone_virtual_network_link = {
  name                  = "PrivateDnsLink"
  private_dns_zone_name = "test-private-dns-zone"
  virtual_network_id    = "VNET-001-001"
}