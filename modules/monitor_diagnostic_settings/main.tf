/*
    Azure Monitor Diagnostic Settings

    Resources
      - Monitor Diagnostic Settings

    Output

    Naming Standards (https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
      - Monitor Diagnostic Settings - mds-<workload/application>-<environment>
*/

# -
# - Monitor Diagnostic Settings
# - 
resource "azurerm_monitor_diagnostic_setting" "mds1" {
  name               = var.name
  target_resource_id = var.target_resource_id #(Required) The ID of an existing Resource on which to configure Diagnostic Settings. Changing this forces a new resource to be created.

  eventhub_name                  = var.eventhub_name == null ? null : var.eventhub_name                                   #(Optional) Specifies the name of the Event Hub where Diagnostics Data should be sent. Changing this forces a new resource to be created.  
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id == null ? null : var.eventhub_authorization_rule_id #(Optional) Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data. Changing this forces a new resource to be created.    
  log_analytics_workspace_id     = var.log_analytics_workspace_id == null ? null : var.log_analytics_workspace_id         #(Optional) Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent.
  log_analytics_destination_type = var.log_analytics_destination_type == null ? null : var.log_analytics_destination_type #(Optional) When set to 'Dedicated' logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table.
  storage_account_id             = var.storage_account_id == null ? null : var.storage_account_id                         #(Optional) The ID of the Storage Account where logs should be sent. Changing this forces a new resource to be created    

  dynamic "log" { #(Optional) One or more log blocks as defined below.
    for_each = var.log_block == null ? null : var.log_block
    content {
      category = log.value["category"] #(Required) The name of a Diagnostic Log Category for this Resource.

      retention_policy {                                           #(Optional) A retention_policy block as defined below.
        enabled = log.value["retention_policy_enabled"]            #(Required) Is this Retention Policy enabled?
        days    = lookup(log.value, "retention_policy_days", null) #(Optional) The number of days for which this Retention Policy should apply.        
      }

      enabled = lookup(log.value, "enabled", null) #(Optional) Is this Diagnostic Log enabled? Defaults to true.    
    }
  }

  dynamic "metric" { #(Optional) One or more metric blocks as defined below.
    for_each = var.metric_block == null ? null : var.metric_block
    content {
      category = metric.value["category"] #(Required) The name of a Diagnostic Metric Category for this Resource.

      retention_policy {                                              #(Optional) A retention_policy block as defined below.
        enabled = metric.value["retention_policy_enabled"]            #(Required) Is this Retention Policy enabled?
        days    = lookup(metric.value, "retention_policy_days", null) #(Optional) The number of days for which this Retention Policy should apply.        
      }

      enabled = lookup(metric.value, "enabled", null) #(Optional) Is this Diagnostic Metric enabled? Defaults to true.      
    }
  }

  lifecycle {
    ignore_changes = [log, metric]
  }
}