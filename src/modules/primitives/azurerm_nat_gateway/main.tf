module "naming" {
  source = "../naming_v2"

  base_name     = var.name
  resource_type = "azurerm_nat_gateway"
}

resource "azurerm_nat_gateway" "this" {
  name                    = module.naming.name
  resource_group_name     = var.resource_group_name
  location                = var.location
  sku_name                = var.sku_name
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  zones                   = var.zones
  tags                    = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  for_each = var.public_ip_ids

  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = each.value
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each = var.subnet_ids

  subnet_id      = each.value
  nat_gateway_id = azurerm_nat_gateway.this.id
}
