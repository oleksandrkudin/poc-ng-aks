module "naming" {
  source = "../naming_v2"

  base_name     = var.name
  resource_type = "azurerm_mysql_flexible_server"
}

resource "random_password" "administrator_password" {
  length  = 24
  special = true
}

resource "azurerm_key_vault_secret" "administrator_password" {
  name         = format("%s-%s", module.naming.name, "administrator-password")
  key_vault_id = var.key_vault_id
  value        = random_password.administrator_password.result
  tags         = var.tags
}

module "identity" {
  source = "../azurerm_user_assigned_identity"

  name                = module.naming.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_mysql_flexible_server" "this" {
  name                         = module.naming.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  administrator_login          = var.administrator_login
  administrator_password       = random_password.administrator_password.result
  backup_retention_days        = var.backup_retention_days
  create_mode                  = var.create_mode
  delegated_subnet_id          = var.delegated_subnet_id
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  identity {
    type         = "UserAssigned"
    identity_ids = [module.identity.id]
  }

  dynamic "high_availability" {
    for_each = var.high_availability == null ? [] : [1]

    content {
      mode                      = var.high_availability.mode
      standby_availability_zone = var.high_availability.standby_availability_zone
    }
  }

  private_dns_zone_id = var.private_dns_zone_id
  sku_name            = var.sku_name

  dynamic "storage" {
    for_each = var.storage == null ? [] : [1]

    content {
      auto_grow_enabled  = var.storage.auto_grow_enabled
      io_scaling_enabled = var.storage.io_scaling_enabled
      iops               = var.storage.iops
      size_gb            = var.storage.size_gb
    }
  }

  version = var.mysql_version
  zone    = var.zone
  tags    = var.tags

  lifecycle {
    ignore_changes = [
      zone,
      high_availability[0].standby_availability_zone
    ]
  }
}

resource "azurerm_mysql_flexible_server_configuration" "this" {
  for_each = var.mysql_server_parameters

  server_name         = azurerm_mysql_flexible_server.this.name
  resource_group_name = var.resource_group_name
  name                = each.key
  value               = each.value
}

resource "azurerm_mysql_flexible_server_active_directory_administrator" "this" {
  for_each = var.active_directory_administrators

  server_id   = azurerm_mysql_flexible_server.this.id
  identity_id = module.identity.id
  tenant_id   = module.identity.tenant_id
  login       = each.value.login
  object_id   = each.value.object_id
}