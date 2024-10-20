terraform {
  source = "../../..//modules/components/iam"
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
  config_path = "../naming"

  mock_outputs_allowed_terraform_commands = ["init", "validate", "refresh", "plan", "show"]
  mock_outputs = {
    name       = "mock-dev"
    tags = {
      mock_tag = "mock_value"
    }
  }
}

dependency "tfstate" {
  config_path                             = "../../tfstate/tfstate"

  mock_outputs_allowed_terraform_commands = ["init", "validate", "refresh", "plan", "show"]
  mock_outputs = {
    role_mappings = {
      Contributor = {
        tfstate = {
          scope = "/subscriptions/df980cf1-51b3-458b-861a-ae9be3ff0e8a/resourceGroups/ok-dev-weu-tfstate-rg/providers/Microsoft.Storage/storageAccounts/mocktfstatesa"
          role_definition_names = [
            "Contributor",
            "Storage Blob Data Contributor"
          ]
        }
      }
    }
  }
}

dependency "base" {
  config_path                             = "../base"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "refresh", "plan", "show"]
  mock_outputs = {
    resource_groups = {
      base = {
        name = "mock-dev-rg"
      }
    }
    role_mappings = {
      Contributor = {
        base = {
          scope = "/subscriptions/df980cf1-51b3-458b-861a-ae9be3ff0e8a/resourceGroups/mock-base-rg-id"
          role_definition_names = [
            "Contributor",
            "Key Vault Secrets Officer"
          ]
        }
        core = {
          scope = "/subscriptions/df980cf1-51b3-458b-861a-ae9be3ff0e8a/resourceGroups/mock-core-rg-id"
          role_definition_names = [
            "Contributor",
            "Key Vault Secrets Officer"
          ]
        }
      }
    }
  }
}

inputs = {
  name                = dependency.naming.outputs.name
  tags                = dependency.naming.outputs.tags
  resource_group_name = dependency.base.outputs.resource_groups["base"].name
  all_role_mappings = {
    tfstate = dependency.tfstate.outputs.role_mappings
    base    = dependency.base.outputs.role_mappings
  }
}