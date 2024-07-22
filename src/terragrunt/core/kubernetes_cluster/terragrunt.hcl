terraform {
  source = "../../..//modules/components/kubernetes_cluster"
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
      core = {
        name = "mock-dev-rg"
      }
    }
    subnets = {
      kubernetes_cluster = {
        id = "/subscriptions/df980cf1-51b3-458b-861a-ae9be3ff0e8a/resourceGroups/mock-dev-rg/providers/Microsoft.Network/virtualNetworks/mock-dev-vnet/subnets/mock-aks-subnet"
      }
      agic = {
        id = "/subscriptions/df980cf1-51b3-458b-861a-ae9be3ff0e8a/resourceGroups/mock-dev-rg/providers/Microsoft.Network/virtualNetworks/mock-dev-vnet/subnets/mock-agw-subnet"
      }
    }
    key_vaults = {
      layer_shared_public = {
        id = "/subscriptions/df980cf1-51b3-458b-861a-ae9be3ff0e8a/resourceGroups/mock-dev-rg/providers/Microsoft.KeyVault/vaults/mockdevkv"
      }
    }
    private_dns_zones = {
      kubernetes_cluster = {
        id = "/subscriptions/df980cf1-51b3-458b-861a-ae9be3ff0e8a/resourceGroups/mock-dev-rg/providers/Microsoft.Network/privateDnsZones/mock.private.dns.zone"
      }
    }
  }
}

inputs = {
  name                = dependency.naming.outputs.name
  tags                = dependency.naming.outputs.tags
  resource_group_name = dependency.base.outputs.resource_groups["core"].name
  key_vault_id        = dependency.base.outputs.key_vaults["layer_shared_public"].id
  default_node_pool = {
    vnet_subnet_id = dependency.base.outputs.subnets["kubernetes_cluster"].id
  }
  private_dns_zone_id = dependency.base.outputs.private_dns_zones["kubernetes_cluster"].id
  agic = {
    subnet_id = dependency.base.outputs.subnets["agic"].id
  }
}