module "resource_group_naming" {
  source = "../../primitives/naming_v2"

  base_name     = module.naming.name
  resource_type = "azurerm_resource_group"
}

module "storage_account_naming" {
  source = "../../primitives/naming_v2"

  base_name     = module.naming.name
  resource_type = "azurerm_storage_account"
}

import {
  for_each = var.create_resource_group || var.create_all ? toset([]) : toset([1])
  to       = module.resource_group.azurerm_resource_group.this
  id       = "/subscriptions/${data.azurerm_client_config.this.subscription_id}/resourceGroups/${module.resource_group_naming.name}"
}

import {
  for_each = var.create_storage_account || var.create_all ? toset([]) : toset([1])
  to       = module.terraform_state.azurerm_storage_account.this
  id       = "/subscriptions/${data.azurerm_client_config.this.subscription_id}/resourceGroups/${module.resource_group_naming.name}/providers/Microsoft.Storage/storageAccounts/${module.storage_account_naming.name}"
}

import {
  for_each = var.create_container || var.create_all ? {} : local.containers
  to       = module.terraform_state.azurerm_storage_container.this[each.key]
  id       = "https://${module.storage_account_naming.name}.blob.core.windows.net/${each.value.name}"
}

import {
  for_each = var.create_role_assignment || var.create_all ? toset([]) : toset([1])
  to       = azurerm_role_assignment.this
  id       = "/subscriptions/${data.azurerm_client_config.this.subscription_id}/resourceGroups/${module.resource_group_naming.name}/providers/Microsoft.Storage/storageAccounts/${module.storage_account_naming.name}/providers/Microsoft.Authorization/roleAssignments/${local.role_assignment_name}"
}

