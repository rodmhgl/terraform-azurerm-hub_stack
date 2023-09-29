module "naming" {
  for_each = toset(local.regions)

  source  = "Azure/naming/azurerm"
  version = "0.3.0"
  prefix  = [lower(var.prefix), lower(var.environment), "hub", each.value]
}
