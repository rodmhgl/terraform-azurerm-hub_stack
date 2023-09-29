locals {
  regions = var.regions

  module_tags = {
    environment = var.environment
    stack       = "hub"
  }

  tags = merge(local.module_tags, var.tags)

}
