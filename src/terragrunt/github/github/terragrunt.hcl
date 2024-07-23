terraform {
  source = "../../..//modules/components/github"
}

include "root" {
  path           = find_in_parent_folders()
  merge_strategy = "deep"
}

include "backend" {
  path = find_in_parent_folders("azurerm_backend.hcl")
}

include "azurerm_provider" {
  path = find_in_parent_folders("azurerm_provider.hcl")
}

dependency "gh_identity" {
  config_path = "../gh_identity"

  mock_outputs_allowed_terraform_commands = ["init", "validate", "refresh", "plan", "show"]
  mock_outputs = {
    client_id = "df980cf1-51b3-458b-861a-ae9be3ff0e8a"
  }
}

inputs = {
  azure_client_id = dependency.gh_identity.outputs.client_id
}