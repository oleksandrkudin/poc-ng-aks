module "naming" {
  source = "../naming_v2"

  base_name     = var.name
  resource_type = "azurerm_key_vault"
}

resource "azurerm_key_vault" "this" {
  name                          = module.naming.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku_name                      = var.sku_name
  tenant_id                     = var.tenant_id
  enabled_for_disk_encryption   = var.enabled_for_disk_encryption
  enable_rbac_authorization     = var.enable_rbac_authorization
  purge_protection_enabled      = var.purge_protection_enabled
  public_network_access_enabled = var.public_network_access_enabled
  soft_delete_retention_days    = var.soft_delete_retention_days

  dynamic "network_acls" {
    for_each = var.network_acls == null ? [] : [1]

    content {
      bypass                     = var.network_acls.bypass
      default_action             = var.network_acls.default_action
      ip_rules                   = var.network_acls.ip_rules
      virtual_network_subnet_ids = var.network_acls.virtual_network_subnet_ids
    }
  }

  tags = var.tags
}