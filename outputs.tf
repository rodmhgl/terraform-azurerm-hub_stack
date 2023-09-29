output "hub_regions" {
  value = local.regions
}

output "hub_firewalls" {
  value = module.hubnetworks.firewalls
}

output "hub_networks" {
  value = module.hubnetworks.virtual_networks
}

output "hub_route_tables" {
  value = module.hubnetworks.hub_route_tables
}

output "hub_subnet_addressing" {
  value = module.subnet_addressing
}

output "hub_base_firewall_policy_id" {
  value = azurerm_firewall_policy.fwpolicy.id
}

output "hub_public_ip_prefixes" {
  value = azurerm_public_ip_prefix.bastion
}

output "hub_private_dns_zones" {
  value = {
    for key, zone in module.private_dns_zones : key => zone.zone_out
  }
}
