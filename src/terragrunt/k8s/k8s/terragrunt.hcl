terraform {
  source = "../../..//modules/components/k8s"
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

  mock_outputs_allowed_terraform_commands = ["init", "validate", "refresh", "plan", "show"]
  mock_outputs = {
    name       = "mock-dev"
    tags = {
      mock_tag = "mock_value"
    }
  }
}

dependency "base" {
  config_path                             = "../../base/base"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "refresh", "plan", "show"]
  mock_outputs = {
    resource_groups = {
      core = {
        name = "mock-dev-rg"
        id = "/subscriptions/df980cf1-51b3-458b-861a-ae9be3ff0e8a/resourceGroups/mock-dev-rg"
      }
    }
  }
}

dependency "kubernetes_cluster" {
  config_path                             = "../../core/kubernetes_cluster"

  mock_outputs_allowed_terraform_commands = ["init", "validate", "refresh", "plan", "show"]
  mock_outputs = {
    agic = {
      name = "mock-agw"
      resource_group_name = "mock-agw-rg"
      id = "/subscriptions/df980cf1-51b3-458b-861a-ae9be3ff0e8a/resourceGroups/mock-agw-rg"
      gateway_ip_configuration = {
        subnet_id = "/subscriptions/df980cf1-51b3-458b-861a-ae9be3ff0e8a/resourceGroups/mock-dev-rg/providers/Microsoft.Network/virtualNetworks/mock-dev-vnet/subnets/mock-agw-subnet"
      }
    }
    kubernetes_cluster = {
      resource_group_id = "/subscriptions/df980cf1-51b3-458b-861a-ae9be3ff0e8a/resourceGroups/mock-aks-rg"
      node_resource_group_id = "/subscriptions/df980cf1-51b3-458b-861a-ae9be3ff0e8a/resourceGroups/mock-aks-managed-rg"
      oidc_issuer_url = "https://oic.prod-aks.azure.com/df980cf1-51b3-458b-861a-ae9be3ff0e8a"
      role_based_access_control_enabled = true
    }
  }
}


inputs = {
  name                = dependency.naming.outputs.name
  tags                = dependency.naming.outputs.tags
  resource_group_name = dependency.base.outputs.resource_groups["core"].name
  agic = dependency.kubernetes_cluster.outputs.agic
  kubernetes_cluster = dependency.kubernetes_cluster.outputs.kubernetes_cluster
}