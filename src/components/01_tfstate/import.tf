import {
  for_each = var.create_resource_group || var.create_all ? toset([]) : toset([1])
  to       = azurerm_resource_group.this
  id       = "/subscriptions/${data.azurerm_client_config.this.subscription_id}/resourceGroups/${local.resource_group_name}"
}

import {
  for_each = var.create_storage_account || var.create_all ? toset([]) : toset([1])
  to       = module.terraform_state.azurerm_storage_account.this
  id       = "/subscriptions/${data.azurerm_client_config.this.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Storage/storageAccounts/${local.storage_account_name}"
}

import {
  for_each = var.create_container || var.create_all ? {} : local.containers
  to       = module.terraform_state.azurerm_storage_container.this[each.key]
  id       = "https://${local.storage_account_name}.blob.core.windows.net/${each.value.name}"
}

import {
  for_each = var.create_role_assignment || var.create_all ? toset([]) : toset([1])
  to       = azurerm_role_assignment.this
  id       = "/subscriptions/${data.azurerm_client_config.this.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Storage/storageAccounts/${local.storage_account_name}/providers/Microsoft.Authorization/roleAssignments/${local.role_assignment_name}"
}
