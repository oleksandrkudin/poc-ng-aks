terraform {
  source = "../../..//modules/components/base"
}

include "root" {
  path           = find_in_parent_folders()
  merge_strategy = "deep"
  expose         = true
}

include "layer" {
  path   = find_in_parent_folders("layer.hcl")
  expose = true
}

include "backend" {
  path = find_in_parent_folders("azurerm_backend.hcl")
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
  name       = dependency.naming.outputs.name
  resource_group_base_name = dependency.naming.outputs.name
  tags       = dependency.naming.outputs.tags
}