module "naming" {
  source = "../naming_v2"

  base_name     = var.name
  resource_type = "azurerm_bastion_host"
}

resource "azurerm_bastion_host" "this" {
  name                   = module.naming.name
  location               = var.location
  resource_group_name    = var.resource_group_name
  copy_paste_enabled     = var.copy_paste_enabled
  file_copy_enabled      = var.file_copy_enabled
  sku                    = var.sku
  ip_connect_enabled     = var.ip_connect_enabled # Allow Bastion to access machines via ExpressRoute or a VPN site-to-site connection using a specified private IP address.
  kerberos_enabled       = var.kerberos_enabled   # Kerberos for target domain-joined VM.
  scale_units            = var.scale_units
  shareable_link_enabled = var.shareable_link_enabled # Lets users connect to a target resource using Azure Bastion without accessing the Azure portal. Self-contained UI with local auth.
  tunneling_enabled      = var.tunneling_enabled      # Native client support (SSH, RDP, tunnel). Personal PC can access VMs behind Bastion. az network bastion ssh.
  virtual_network_id     = var.virtual_network_id     # Azure DevTest Labs

  ip_configuration {
    name                 = "main"
    subnet_id            = var.subnet_id
    public_ip_address_id = var.public_ip_address_id
  }

  tags = var.tags
}