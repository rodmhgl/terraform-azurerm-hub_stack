## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.4.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.70.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.70.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_hubnetworks"></a> [hubnetworks](#module\_hubnetworks) | Azure/hubnetworking/azurerm | 1.1.0 |
| <a name="module_naming"></a> [naming](#module\_naming) | Azure/naming/azurerm | 0.3.0 |
| <a name="module_naming_firewall_policy"></a> [naming\_firewall\_policy](#module\_naming\_firewall\_policy) | Azure/naming/azurerm | 0.3.0 |
| <a name="module_naming_public_ips"></a> [naming\_public\_ips](#module\_naming\_public\_ips) | Azure/naming/azurerm | 0.3.0 |
| <a name="module_private_dns_zones"></a> [private\_dns\_zones](#module\_private\_dns\_zones) | ../PrivateDNSZone | n/a |
| <a name="module_subnet_addressing"></a> [subnet\_addressing](#module\_subnet\_addressing) | hashicorp/subnets/cidr | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall_policy.fwpolicy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy) | resource |
| [azurerm_firewall_policy_rule_collection_group.allow_internal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |
| [azurerm_public_ip_prefix.hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip_prefix) | resource |
| [azurerm_resource_group.fwpolicy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.private_dns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.public_ips](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment to deploy to. Valid values are sim, nprd, and prd. | `string` | `"sim"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix to use for all resources in this deployment. | `string` | `"dbdemo"` | no |
| <a name="input_private_dns_zones"></a> [private\_dns\_zones](#input\_private\_dns\_zones) | n/a | `map(object({}))` | <pre>{<br>  "privatelink.azurecr.io": {},<br>  "privatelink.blob.core.windows.net": {},<br>  "privatelink.cassandra.cosmos.azure.com": {},<br>  "privatelink.documents.azure.com": {},<br>  "privatelink.eastus.azmk8s.io": {},<br>  "privatelink.eastus2.azmk8s.io": {},<br>  "privatelink.eus.backup.windowsazure.com": {},<br>  "privatelink.eus2.backup.windowsazure.com": {},<br>  "privatelink.file.core.windows.net": {},<br>  "privatelink.gremlin.cosmos.azure.com": {},<br>  "privatelink.managedhsm.azure.net": {},<br>  "privatelink.mongo.cosmos.azure.com": {},<br>  "privatelink.monitor.azure.com": {},<br>  "privatelink.queue.core.windows.net": {},<br>  "privatelink.servicebus.windows.net": {},<br>  "privatelink.siterecovery.windowsazure.com": {},<br>  "privatelink.table.core.windows.net": {},<br>  "privatelink.table.cosmos.azure.com": {},<br>  "privatelink.vaultcore.azure.net": {},<br>  "privatelink.web.core.windows.net": {}<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_base_firewall_policy_id"></a> [base\_firewall\_policy\_id](#output\_base\_firewall\_policy\_id) | n/a |
| <a name="output_hub_firewalls"></a> [hub\_firewalls](#output\_hub\_firewalls) | n/a |
| <a name="output_hub_networks"></a> [hub\_networks](#output\_hub\_networks) | n/a |
| <a name="output_hub_regions"></a> [hub\_regions](#output\_hub\_regions) | n/a |
| <a name="output_hub_route_tables"></a> [hub\_route\_tables](#output\_hub\_route\_tables) | n/a |
| <a name="output_hub_subnet_addressing"></a> [hub\_subnet\_addressing](#output\_hub\_subnet\_addressing) | n/a |
| <a name="output_private_dns_zones"></a> [private\_dns\_zones](#output\_private\_dns\_zones) | n/a |
| <a name="output_public_ip_prefixes"></a> [public\_ip\_prefixes](#output\_public\_ip\_prefixes) | n/a |
