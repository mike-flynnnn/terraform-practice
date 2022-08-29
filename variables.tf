variable "location" {
  type        = string
  description = "Default resources location."
  default     = "East US"
}

variable "resource_group_name" {
  type        = string
  description = "Default Resource Group."
  default     = "rg-network-eastus-001"
}

variable "environment" {
  type        = string
  description = "The working environement (dev, uat, prod)."
  default     = ""
}

variable "resource_tags" {
  description = "Tags for the Resource Group and child resources."
  type        = any
  default     = {}
}


variable "log_analytics_workspaces" {
  description = "The Log analytics Workspaces with their properties."
  type        = any
  default     = {}
}

variable "virtual_networks" {
  description = "Virtual Networks to create with their configurations"
  type        = any
  default     = {}
}

variable "virtual_network_peerings" {
  description = "Virtual Network Peering to create with their configurations"
  type        = any
  default     = {}
}

variable "subnets" {
  description = "Subnets to create with their configurations"
  type        = any
  default     = {}
}

variable "route_tables" {
  description = "Route Tables with their properties"
  type        = any
  default     = {}
}

variable "route_table_association" {
  description = "Route Table Association to Subnet"
  type        = any
  default     = {}
}

variable "vnet_monitor_diagnostic_settings" {
  description = "The Monitor Diagnostic Settings with their properties."
  type        = any
  default     = {}
}

variable "network_security_group" {
  description = "The security rules for the Network Security Group"
  type        = any
  default     = {}
}

variable "subnet_network_security_group_association" {
  description = "Associates the Network Security Group with the subnets"
  type        = any
  default     = {}
}

variable "virtual_wan" {
  description = "Manages transit connectivity between VPN and ExpressRoute"
  type        = any
  default     = {}
}

variable "virtual_hub" {
  description = "Manages a Virtual Hub within a Virtual WAN"
  type        = any
  default     = {}
}

variable "virtual_hub_connection" {
  description = "Manages a connection for a Virtual Hub"
  type        = any
  default     = {}
}

variable "private_dns_zone" {
  description = "Manage a Private DNS Zone within Azure DNS"
  type        = any
  default     = {}
}

variable "private_dns_zone_virtual_network_link" {
  description = "Manage Private DNS Zone Virtual Network links"
  type        = any
  default     = {}
}
