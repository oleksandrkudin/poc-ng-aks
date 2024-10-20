# Naming
module "naming" {
  source = "../../primitives/naming_v2"

  base_name = var.name
  component = "bastion"
}

#
module "inbound_mgmt_connectitity_pip_naming" {
  source = "../../primitives/naming_v2"

  base_name = var.name
  component = "inbound-mgmt"
}

module "inbound_mgmt_connectitity_pip" {
  source = "../../primitives/azurerm_public_ip_address"

  name                = module.inbound_mgmt_connectitity_pip_naming.name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.inbound_mgmt_connectitity.allocation_method
  sku                 = var.inbound_mgmt_connectitity.sku
  zones               = var.inbound_mgmt_connectitity.sku == "Standard" ? var.zones : null
  tags                = var.tags
}

module "bastion" {
  source               = "../../primitives/azurerm_bastion_host"
  name                 = module.naming.name
  location             = var.location
  resource_group_name  = var.resource_group_name
  subnet_id            = var.subnet_id
  public_ip_address_id = module.inbound_mgmt_connectitity_pip.id
}
