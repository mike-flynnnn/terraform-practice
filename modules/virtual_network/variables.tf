// -
// - General
// -

variable "virtual_network_rg" {
  description = "The Virtual Network resources group name."
  type        = string
}

variable "environment" {
  description = "Current environment"
  type        = string
}

// -
// - Load Existing Resources
// -
variable "existing_ddos_protection_plans" {
  description = "Existing DDoS Protection Plans in a List with Name and Resource Group"
  type        = any
  default     = {}
}

variable "existing_route_tables" {
  description = "Existing Network Security Groups in a List with Name and Resource Group"
  type        = any
  default     = {}
}

variable "existing_network_security_groups" {
  description = "Existing Network Security Groups in a List with Name and Resource Group"
  type        = any
  default     = {}
}

variable "log_analytics_workspace" {
  description = "The Log Analytics Workspaces with their properties."
  type        = any
}

// -
// - Resources
// -
variable "ddos_protection_plans" {
  description = "DDoS Protection plans to create with their configuration"
  type        = any
  default     = {}
}

variable "network_security_groups" {
  description = "Netowrk Security Groups to create with their configuration"
  type        = any
  default     = {}
}

variable "route_tables" {
  description = "Route Tables to create with their configurations"
  type        = any
  default     = {}
}

variable "virtual_networks" {
  description = "Virtual Networks to create with their configurations"
  type        = any
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

variable "route_table_association" {
  description = "Route Table Association to Subnet"
  type        = any
  default     = {}
}

variable "network_security_group_association" {
  description = "Network Security Group to Subnet"
  type        = any
  default     = {}
}

// -
// - Logging
// -
variable "monitor_diagnostic_settings" {
  description = "The Monitor Diagnostic Settings with their properties."
  type        = any
}

// -
// - Other
// -
variable "null_array" {
  description = ""
  default     = []
}