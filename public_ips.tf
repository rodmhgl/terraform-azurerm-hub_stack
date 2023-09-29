locals {
  public_ip_prefix_tags = merge(local.tags, {
    "role" = "hub_bastion_public_ip_prefix"
  })
}

module "naming_public_ips" {
  for_each = toset(local.regions)

  source  = "Azure/naming/azurerm"
  version = "0.3.0"
  prefix  = [lower(var.prefix), lower(var.environment), "pips", each.value]
}

resource "azurerm_resource_group" "public_ips" {
  for_each = toset(local.regions)

  location = each.value
  name     = module.naming_public_ips[each.value].resource_group.name
  tags     = local.tags
}

resource "azurerm_public_ip_prefix" "bastion" {
  for_each = toset(local.regions)

  name                = module.naming_public_ips[each.value].public_ip_prefix.name
  location            = azurerm_resource_group.public_ips[each.value].location
  resource_group_name = azurerm_resource_group.public_ips[each.value].name
  prefix_length       = 31
  zones               = [] # TODO: Add availability zones
  tags                = local.public_ip_prefix_tags
}
