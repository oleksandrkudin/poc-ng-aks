# Base name
module "naming" {
  source = "../../../modules/naming"

  product_short_name    = var.product_short_name
  location_short_name   = var.location_short_name
  deployment_short_name = var.deployment_short_name
}

# Base tags
module "tags" {
  source = "../../../modules/tags"

  product_name     = var.product_name
  environment_name = var.environment_name
}

# Resource groups
resource "azurerm_resource_group" "this" {
  for_each = local.resource_groups
  name     = format("%s-%s-%s", module.naming.name, each.key, "rg")
  location = var.location
  tags     = module.tags.tags
}

# Base Networking
module "networking" {
  source              = "../../../modules/azurerm_networking"
  name                = format("%s-%s", local.name, "vnet")
  resource_group_name = azurerm_resource_group.this["base"].name
  location            = var.location
  address_space       = var.networking.address_space
  subnets             = var.networking.subnets
  tags                = module.tags.tags
}

# Outbound connectivity
locals {
  outbound_connectitity_public_ip = toset([for index in range(1, var.outbound_connectitity_public_ips.count + 1) : format("%02d", index)])
}

resource "azurerm_public_ip" "outbound_connectitity" {
  for_each = local.outbound_connectitity_public_ip

  name                = format("%s-%s-%s", local.name, "outbound-pip", each.value)
  location            = var.location
  resource_group_name = azurerm_resource_group.this["base"].name
  allocation_method   = var.outbound_connectitity_public_ips.allocation_method
  sku                 = var.outbound_connectitity_public_ips.sku
  zones               = var.zones
  tags                = module.tags.tags
}

module "nat_gateway" {
  source              = "../../../modules/azurerm_nat_gateway"
  name                = format("%s-%s", local.name, "ng")
  resource_group_name = azurerm_resource_group.this["base"].name
  location            = var.location
  public_ip_ids       = { for key in local.outbound_connectitity_public_ip : key => azurerm_public_ip.outbound_connectitity[key].id }
  subnet_ids          = { for key, value in module.networking.subnets : key => value.id }
  zones               = var.zones
  tags                = module.tags.tags
}

# Secrets storage
module "service_shared_public_key_vault" {
  source                     = "../../../modules/azurerm_key_vault"
  name                       = format("%s%s%s", local.short_name, "shrpub", "kv")
  resource_group_name        = azurerm_resource_group.this["base"].name
  location                   = var.location
  tenant_id                  = data.azurerm_client_config.this.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
  enable_rbac_authorization  = true
  tags                       = module.tags.tags
}
