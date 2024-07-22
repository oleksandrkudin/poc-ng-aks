module "naming" {
  source = "../naming_v2"

  base_name     = var.name
  resource_type = "azurerm_resource_group"
}

resource "azurerm_resource_group" "this" {
  name       = module.naming.name
  location   = var.location
  managed_by = var.managed_by
  tags       = var.tags
}