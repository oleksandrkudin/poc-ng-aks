module "naming" {
  source = "../naming_v2"

  base_name     = var.name
  resource_type = "azurerm_virtual_network"
}

# Virtual Network
resource "azurerm_virtual_network" "this" {
  name                = module.naming.name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  tags                = var.tags
}

# Subnets
resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                 = coalesce(each.value.name, each.key)
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes

  dynamic "delegation" {
    for_each = each.value.delegations

    content {
      name = coalesce(delegation.value.name, delegation.key)
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}

# Network Security Groups
locals {
  network_security_groups = { for key, value in var.subnets : key => {} if value.create_network_security_group }
}

module "network_security_group_naming" {
  for_each = local.network_security_groups

  source = "../naming_v2"

  base_name     = var.name
  resource_type = "azurerm_network_security_group"
  resource_name = each.key
}

resource "azurerm_network_security_group" "this" {
  for_each = local.network_security_groups

  name                = module.network_security_group_naming[each.key].name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = local.network_security_groups

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}

# Private DNS zones
resource "azurerm_private_dns_zone" "this" {
  for_each = var.private_dns_zones

  name                = coalesce(each.value.name, each.key)
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = var.private_dns_zones

  name                  = format("%s-%s", azurerm_private_dns_zone.this[each.key].name, azurerm_virtual_network.this.name)
  private_dns_zone_name = azurerm_private_dns_zone.this[each.key].name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = each.value.virtual_network_link.registration_enabled
  tags                  = var.tags
}
