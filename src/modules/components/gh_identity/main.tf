# Naming
module "naming" {
  source = "../../primitives/naming_v2"

  base_name = var.name
  component = "gh_identity"
}

# GitHub repository environment identity
module "gh_identity" {
  source = "../../primitives/azurerm_user_assigned_identity"

  name                = module.naming.name
  resource_group_name = var.resource_group_name
  location            = var.location

  federated_identity_credentials = {
    github_repository_environment = {
      audience = ["api://AzureADTokenExchange"]
      issuer   = "https://token.actions.githubusercontent.com"
      subject  = "repo:${var.github_repository}:environment:${var.environment}"
    }
  }

  role_mappings = local.combined_role_mappings["Contributor"]
  tags = var.tags
}
