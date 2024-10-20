locals {
  component_short_name = "tfstate"

  name       = format("%s-%s", module.naming.name, local.component_short_name)
  short_name = format("%s%s", module.naming.short_name, local.component_short_name)

  resource_group_name  = format("%s-%s", local.name, "rg")
  storage_account_name = format("%s%s%s", local.short_name, "tfstate", "sa")
  role_assignment_name = data.azurerm_client_config.this.object_id

  containers = {
    tfstate = {
      name = var.terraform_state.container_name
    }
  }
}