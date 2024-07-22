locals {
  roles = ["Owner", "Contributor", "Reader"]

  combined_role_mappings = { for role in local.roles : role => merge(flatten([
    for role_mappings in values(var.all_role_mappings) : try(role_mappings[role], {})
  ])...) }

  identity_role_mappings = {
    current_identity = {
      principal_id = data.azurerm_client_config.this.object_id
      role         = "Contributor"
    }
    # github_repository_environment_identity = {
    #   principal_id = module.github_repository_environment_identity.principal_id
    #   role         = "Contributor"
    # }
  }

  # TODO: Extend to Users, Groups; Apps, User Assigned Identities created outside this product.
}