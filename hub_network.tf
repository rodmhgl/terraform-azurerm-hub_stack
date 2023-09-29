locals {
  diagnostics_map = {
    for r in var.regions : r => {
      diags_sa = module.diag_helper.diagnostics_stack[r].storage_account_id // data.azurerm_storage_account.monitoring[r].id
      eh_id    = module.diag_helper.diagnostics_stack[r].event_hub_namespace_id
      eh_name  = module.diag_helper.diagnostics_stack[r].event_hub_namespace_name
      law_id   = module.diag_helper.diagnostics_stack[r].log_analytics_workspace_id
    }
  }
  address_spaces = zipmap(var.regions, var.address_spaces)

  # tflint-ignore: terraform_unused_declarations
  firewall_tags = merge(local.tags, {
    "role" = "hub_firewall"
  })
  network_tags = merge(local.tags, {
    "role" = "hub_virtual_network"
  })

  subnet_cidrs = [
    {
      name     = "integration"
      new_bits = 8
    },
    {
      name     = "integration2"
      new_bits = 8
    },
    {
      name     = "integration3"
      new_bits = 8
    },
    {
      name     = "ehsplunk"
      new_bits = 8
    },
    {
      name     = "ServiceNowVM"
      new_bits = 8
    },
    {
      name     = "GatewaySubnet"
      new_bits = 7
    },
    {
      name     = "AzureFirewallSubnet"
      new_bits = 3
    },
    {
      name     = "AzureBastionSubnet"
      new_bits = 3
    },
    {
      name     = "vmss"
      new_bits = 3
    },
    {
      name     = "pvtendpoint"
      new_bits = 1
    },
  ]

  special_subnets = ["AzureBastionSubnet", "AzureFirewallSubnet", "GatewaySubnet", ]

  # Maintain subnet name if in special_subnets, otherwise use naming module
  subnets = {
    for region in local.regions : region => {
      for subnet in local.subnet_cidrs :
      contains(local.special_subnets, subnet.name) ? subnet.name :
      "${module.naming[region].subnet.name}-${subnet.name}" => {
        address_prefixes             = [module.subnet_addressing[region].network_cidr_blocks[subnet.name]],
        assign_generated_route_table = subnet.name == "AzureBastionSubnet" || subnet.name == "GatewaySubnet" ? false : null
      }
    }
  }

  hub_virtual_networks = {
    for r in var.regions : r => {
      address_space                   = [local.address_spaces[r]]
      name                            = module.naming[r].firewall.name
      location                        = azurerm_resource_group.hub[r].location
      resource_group_name             = azurerm_resource_group.hub[r].name
      resource_group_creation_enabled = false
      resource_group_lock_enabled     = false
      mesh_peering_enabled            = true
      routing_address_space           = [local.address_spaces[r]]
      tags                            = local.network_tags
      hub_router_ip_address           = "1.2.3.4"
      flow_timeout_in_minutes         = 4
      subnets                         = local.subnets[r]
      # subnets = {
      # firewall = {
      #   sku_name              = "AZFW_VNet"
      #   sku_tier              = "Standard"
      #   threat_intel_mode     = "Off"
      #   subnet_address_prefix = module.subnet_addressing[r].network_cidr_blocks["AzureFirewallSubnet"]
      #   subnet_address_prefix = module.subnet_addressing[r].network_cidr_blocks["AzureFirewallSubnet"]
      #   firewall_policy_id    = azurerm_firewall_policy.fwpolicy.id
      #   tags                  = local.firewall_tags
      # }
    }
  }

}

resource "azurerm_resource_group" "hub" {
  for_each = toset(local.regions)

  location = each.value
  name     = module.naming[each.value].resource_group.name
  tags     = local.tags
}

# locals {
#   subnets = [
#     {
#       name     = "integration"
#       new_bits = 8
#     },
#     {
#       name     = "integration2"
#       new_bits = 8
#     },
#     {
#       name     = "integration3"
#       new_bits = 8
#     },
#     {
#       name     = "ehsplunk"
#       new_bits = 8
#     },
#     {
#       name     = "ServiceNowVM"
#       new_bits = 8
#     },
#     {
#       name     = "GatewaySubnet"
#       new_bits = 7
#     },
#     {
#       name     = "AzureFirewallSubnet"
#       new_bits = 3
#     },
#     {
#       name     = "AzureBastionSubnet"
#       new_bits = 3
#     },
#     {
#       name     = "vmss"
#       new_bits = 3
#     },
#     {
#       name     = "pvtendpoint"
#       new_bits = 1
#     },
#   ]
# }

module "subnet_addressing" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  for_each = local.address_spaces

  base_cidr_block = each.value
  networks        = local.subnet_cidrs
}

module "hubnetworks" {
  source               = "Azure/hubnetworking/azurerm"
  version              = "1.1.0"
  hub_virtual_networks = local.hub_virtual_networks
  depends_on           = [azurerm_firewall_policy_rule_collection_group.allow_internal]
}

module "diag_helper" {
  source      = "./diag_helper"
  regions     = var.regions
  prefix      = var.prefix
  environment = var.environment
}

output "diag_helper" {
  value = module.diag_helper
}

data "azurerm_monitor_diagnostic_categories" "virtual_networks" {
  for_each    = module.hubnetworks.virtual_networks
  resource_id = each.value.id
}

data "azurerm_monitor_diagnostic_categories" "firewalls" {
  for_each    = module.hubnetworks.firewalls
  resource_id = each.value.id
}

module "firewall_diagnostics" {
  for_each = module.hubnetworks.firewalls

  source        = "github.com/rodmhgl/terraform-azurerm-azuremonitoronboarding?ref=v1.0.1"
  resource_name = each.value.name
  resource_id   = each.value.id
  diagnostics_logs_map = {
    log    = [for log in data.azurerm_monitor_diagnostic_categories.firewalls[each.key].log_category_types : [log, true, 30]],
    metric = [for metric in data.azurerm_monitor_diagnostic_categories.firewalls[each.key].metrics : [metric, true, 30]],
  }
  diagnostics_map                   = local.diagnostics_map[each.key]
  log_analytics_workspace_dedicated = "Dedicated"
  log_analytics_workspace_id        = local.diagnostics_map[each.key].law_id
}

module "virtual_network_diagnostics" {
  for_each = module.hubnetworks.virtual_networks

  source        = "github.com/rodmhgl/terraform-azurerm-azuremonitoronboarding?ref=v1.0.1"
  resource_name = each.value.name
  resource_id   = each.value.id
  diagnostics_logs_map = {
    log    = [for log in data.azurerm_monitor_diagnostic_categories.virtual_networks[each.key].log_category_types : [log, true, 30]],
    metric = [for metric in data.azurerm_monitor_diagnostic_categories.virtual_networks[each.key].metrics : [metric, true, 30]],
  }
  diagnostics_map                   = local.diagnostics_map[each.value.location]
  log_analytics_workspace_dedicated = "Dedicated"
  log_analytics_workspace_id        = local.diagnostics_map[each.value.location].law_id
}
