terraform {
  source = "../../..//modules/components/tfstate"
}

include "root" {
  path           = find_in_parent_folders()
  merge_strategy = "deep"
  expose         = true
}

remote_state {
  backend = "local"
  generate = {
    path      = "local_backend.tf"
    if_exists = "overwrite"
  }
  config = {
    path = "/tmp/tfstate_terraform.tfstate"
  }
}

include "azurerm_provider" {
  path = find_in_parent_folders("azurerm_provider.hcl")
}

dependency "naming" {
  config_path = "../naming"

  mock_outputs_allowed_terraform_commands = ["init", "validate", "refresh", "plan", "show"]
  mock_outputs = {
    name       = "mock-dev"
    tags = {
      mock_tag = "mock_value"
    }
  }
}

inputs = {
  name                           = dependency.naming.outputs.name
  tags                           = dependency.naming.outputs.tags
  terragrunt_remote_backend_path = "${get_repo_root()}/src/terragrunt/azurerm_backend.hcl"
}