# Naming
module "naming" {
  source = "../../primitives/naming_v2"

  base_name = var.name
  component = "jump"
}

# Jump host
module "jump_host" {
  source                      = "../../primitives/azurerm_linux_vmss"
  name                        = module.naming.name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  sku                         = var.jump.sku
  instances                   = 1
  admin_username              = var.jump.admin_username
  platform_fault_domain_count = var.jump.platform_fault_domain_count
  subnet_id                   = var.subnet_id
  key_vault_id                = var.key_vault_id
  zones                       = var.zones

  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = var.tags
}