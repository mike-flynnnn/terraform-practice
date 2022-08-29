variable "name" {
  description = "The name of the MDS resource"
  type        = string
}

variable "target_resource_id" {
  description = "The resource ID of the MDS resource"
  type        = string
}

variable "eventhub_name" {
  description = "The name of the eventhub"
  type        = string
  default     = null
}

variable "eventhub_authorization_rule_id" {
  description = "The ID of the eventhub authorization rule"
  type        = string
  default     = null
}

variable "log_analytics_workspace_id" {
  description = "The Resource ID of the Log Analytics workspace"
  type        = string
  default     = null
}

variable "log_analytics_destination_type" {
  description = "The log analytics destination type"
  type        = string
  default     = null
}

variable "storage_account_id" {
  description = "The Storage Account ID"
  type        = string
  default     = null
}

variable "log_block" {
  description = "The log configuration for MDS"
  type        = any
  default     = {}
}

variable "metric_block" {
  description = "The metrics to collect"
  type        = any
  default     = {}
}