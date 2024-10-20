# Naming
module "naming" {
  source = "../../primitives/naming_v2"

  base_name = var.name
  component = "iam"
}

# GitHub repository environment identity
# module "github_repository_environment_identity_naming" {
#   source = "../../primitives/naming_v2"

#   base_name = module.naming.name
#   component = "github"
# }

# module "github_repository_environment_identity" {
#   source = "../../primitives/azurerm_user_assigned_identity"

#   name                = module.github_repository_environment_identity_naming.name
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   federated_identity_credentials = {
#     github_repository_environment = {
#       audience = ["api://AzureADTokenExchange"]
#       issuer   = "https://token.actions.githubusercontent.com"
#       subject  = "repo:${var.github_repository}:environment:${var.environment}"
#     }
#   }
#   tags = var.tags
# }

# Role mappings
module "role_assignment" {
  source   = "../../primitives/azurerm_role_mapping"
  for_each = local.identity_role_mappings

  principal_id  = each.value.principal_id
  role_mappings = local.combined_role_mappings[each.value.role]
}
