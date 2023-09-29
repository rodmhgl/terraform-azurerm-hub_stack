# output "log_analytics_workspace_id" {
#   value = {
#     for r in var.regions :
#     r => data.azurerm_log_analytics_workspace.monitoring[r].id
#   }
# }

# output "storage_account_id" {
#   value = {
#     for r in var.regions :
#     r => data.azurerm_storage_account.monitoring[r].id
#   }
# }

# output "event_hub_namespace_id" {
#   value = {
#     for r in var.regions :
#     r => data.azurerm_eventhub_namespace.monitoring[r].id
#   }
# }

# output "event_hub_namespace_name" {
#   value = {
#     for r in var.regions :
#     r => data.azurerm_eventhub_namespace.monitoring[r].name
#   }
# }

output "diagnostics_stack" {
  value = {
    for r in var.regions : r => {
      log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.monitoring[r].id
      log_analytics_workspace_name   = data.azurerm_log_analytics_workspace.monitoring[r].name
      storage_account_id             = data.azurerm_storage_account.monitoring[r].id
      storage_account_name           = data.azurerm_storage_account.monitoring[r].name
      event_hub_namespace_id         = data.azurerm_eventhub_namespace.monitoring[r].id
      event_hub_namespace_name       = data.azurerm_eventhub_namespace.monitoring[r].name
      monitoring_resource_group_name = local.diagnostics_stack[r].monitoring_resource_group_name
    }
  }
}
