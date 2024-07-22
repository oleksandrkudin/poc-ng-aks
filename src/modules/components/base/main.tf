# Naming
module "naming" {
  source = "../../primitives/naming_v2"

  base_name = var.name
  component = "base"
}

# Resource groups
module "resource_group_naming" {
  source = "../../primitives/naming_v2"

  for_each = local.resource_groups

  base_name     = module.naming.name
  resource_name = each.key
}

module "resource_group" {
  source = "../../primitives/azurerm_resource_group"

  for_each = local.resource_groups

  name = module.resource_group_naming[each.key].name
  location = var.location
  tags = var.tags
}

# Base Networking
module "networking" {
  source              = "../../primitives/azurerm_networking"
  name                = module.naming.name
  resource_group_name = module.resource_group["base"].name
  location            = var.location
  address_space       = var.networking.address_space
  subnets             = var.networking.subnets
  private_dns_zones   = local.private_dns_zones
  tags                = var.tags
}

# Outbound connectivity
locals {
  # outbound_connectitity_public_ip = toset([for index in range(1, var.outbound_connectitity_public_ips.count + 1) : format("%02d", index)])
  outbound_connectitity_public_ip = toset([])
}

module "outbound_connectitity_naming" {
  source = "../../primitives/naming_v2"

  for_each = local.outbound_connectitity_public_ip

  base_name     = module.naming.name
  component     = "outbound"
  resource_type = "azurerm_public_ip"
  resource_name = each.value
}

module "outbound_connectitity_pip" {
  source = "../../primitives/azurerm_public_ip_address"

  for_each = local.outbound_connectitity_public_ip

  name                = module.outbound_connectitity_naming[each.value].name
  location            = var.location
  resource_group_name = module.resource_group["base"].name
  allocation_method   = var.outbound_connectitity_public_ips.allocation_method
  sku                 = var.outbound_connectitity_public_ips.sku
  zones               = var.zones
  tags                = var.tags
}

module "nat_gateway" {
  count               = 0
  source              = "../../primitives/azurerm_nat_gateway"
  name                = module.naming.name
  resource_group_name = module.resource_group["base"].name
  location            = var.location
  public_ip_ids       = { for key in local.outbound_connectitity_public_ip : key => module.outbound_connectitity_pip[key].id }
  subnet_ids          = { for key, value in module.networking.subnets : key => value.id }
  zones               = var.zones
  tags                = var.tags
}

# Secrets storage
module "shared_public_kv_name" {
  source = "../../primitives/naming_v2"

  base_name     = module.naming.name
  resource_type = "azurerm_key_vault"
  resource_name = "shrpub"
}

module "shared_public_key_vault" {
  source                     = "../../primitives/azurerm_key_vault"
  name                       = module.shared_public_kv_name.name
  resource_group_name        = module.resource_group["base"].name
  location                   = var.location
  tenant_id                  = data.azurerm_client_config.this.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
  enable_rbac_authorization  = true
  tags                       = var.tags
}

# Network security rules
resource "azurerm_network_security_rule" "this" {
  for_each = local.combined_network_security_rules

  resource_group_name         = module.resource_group["base"].name
  network_security_group_name = module.networking.network_security_groups[each.value.network_security_group_key].name

  name                                       = try(each.value.name, each.value.rule_key)
  description                                = try(each.value.description, null)
  protocol                                   = each.value.protocol
  access                                     = each.value.access
  priority                                   = each.value.priority
  direction                                  = each.value.direction
  source_port_range                          = try(each.value.source_port_range, null)
  source_port_ranges                         = try(each.value.source_port_ranges, null)
  destination_port_range                     = try(each.value.destination_port_range, null)
  destination_port_ranges                    = try(each.value.destination_port_ranges, null)
  source_address_prefix                      = try(each.value.source_address_prefix, null)
  source_address_prefixes                    = try(each.value.source_address_prefixes, null)
  source_application_security_group_ids      = try(each.value.source_application_security_group_ids, null)
  destination_address_prefix                 = try(each.value.destination_address_prefix, null)
  destination_address_prefixes               = try(each.value.destination_address_prefixes, null)
  destination_application_security_group_ids = try(each.value.destination_application_security_group_ids, null)
}
