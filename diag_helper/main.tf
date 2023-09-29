locals {
  # diagnostics_map = {
  #   for r in var.regions : r => {
  #     diags_sa = data.azurerm_storage_account.monitoring[r].id
  #     eh_id    = data.azurerm_eventhub_namespace.monitoring[r].id
  #     eh_name  = data.azurerm_eventhub_namespace.monitoring[r].name
  #   }
  # }

  diagnostics_stack = {
    for r in var.regions : r => {
      monitoring_workspace_name           = "${var.prefix}-${var.environment}-azmon-${r}-log"
      monitoring_event_hub_namespace_name = "${var.prefix}-${var.environment}-azmon-${r}-ehn"
      monitoring_resource_group_name      = "${var.prefix}-${var.environment}-azmon-${r}-rg"
    }
  }
}

data "azurerm_log_analytics_workspace" "monitoring" {
  for_each = toset(var.regions)

  name                = local.diagnostics_stack[each.value].monitoring_workspace_name
  resource_group_name = local.diagnostics_stack[each.value].monitoring_resource_group_name
}

data "azurerm_eventhub_namespace" "monitoring" {
  for_each = toset(var.regions)

  name                = local.diagnostics_stack[each.value].monitoring_event_hub_namespace_name
  resource_group_name = local.diagnostics_stack[each.value].monitoring_resource_group_name
}

data "azurerm_resources" "monitoring" {
  for_each = toset(var.regions)

  type                = "Microsoft.Storage/storageAccounts"
  resource_group_name = local.diagnostics_stack[each.value].monitoring_resource_group_name
  required_tags = {
    "role" = "diagnostics"
  }
}

data "azurerm_storage_account" "monitoring" {
  for_each = toset(var.regions)

  name                = data.azurerm_resources.monitoring[each.value].resources[0].name
  resource_group_name = local.diagnostics_stack[each.value].monitoring_resource_group_name
}
