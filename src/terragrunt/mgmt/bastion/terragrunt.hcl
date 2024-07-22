terraform {
  source = "../../..//modules/components/bastion"
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

dependency "naming" {
  config_path = "../../base/naming"

  mock_outputs_allowed_terraform_commands = ["init", "validate", "refresh", "plan"]
  mock_outputs = {
    name       = "mock-dev"
    tags = {
      mock_tag = "mock_value"
    }
  }
}

dependency "base" {
  config_path                             = "../../base/base"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "refresh", "plan"]
  mock_outputs = {
    resource_groups = {
      mgmt = {
        name = "mock-dev-rg"
      }
    }
    subnets = {
      bastion = {
        id = "/subscriptions/df980cf1-51b3-458b-861a-ae9be3ff0e8a/resourceGroups/mock-dev-rg/providers/Microsoft.Network/virtualNetworks/mock-dev-vnet/subnets/mock-subnet"
      }
    }
  }
}

inputs = {
  name                = dependency.naming.outputs.name
  tags                = dependency.naming.outputs.tags
  resource_group_name = dependency.base.outputs.resource_groups["mgmt"].name
  subnet_id           = dependency.base.outputs.subnets["bastion"].id
}