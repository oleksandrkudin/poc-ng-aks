locals {
  role_assignment_name = data.azurerm_client_config.this.object_id

  containers = {
    tfstate = {
      name = var.terraform_state.container_name
    }
  }

  role_mappings = {
    Contributor = {
      tfstate = {
        scope = module.resource_group.id
        role_definition_names = [
          "Contributor",
          "Storage Blob Data Contributor"
        ]
      }
    }
  }
}