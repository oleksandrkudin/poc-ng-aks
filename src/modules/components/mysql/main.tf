# Naming
module "naming" {
  source = "../../primitives/naming_v2"

  base_name = var.name
  component = "db"
}

module "mysql" {
  source                = "../../primitives/azurerm_mysql_flexible_server"
  name                  = module.naming.name
  resource_group_name   = var.resource_group_name
  location              = var.location
  key_vault_id          = var.key_vault_id
  administrator_login   = "sqladmin"
  backup_retention_days = 1
  mysql_version         = "8.0.21"
  delegated_subnet_id   = var.delegated_subnet_id
  private_dns_zone_id   = var.private_dns_zone_id
  sku_name              = "GP_Standard_D2ads_v5"
  storage = {
    size_gb = 32
  }
  zone = var.zones[0]
  tags = var.tags
}