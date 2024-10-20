locals {
  outbound_connectitity_public_ips = [for index in range(1, var.outbound_connectitity_public_ips.count + 1) : format("%02d", index)]

  resource_groups = {
    base = {}
    mgmt = {}
    core = {}
    # k8s = {}
    # app = {}
  }

  # Product RBAC roles for Azure part
  role_mappings = {
    Contributor = {
      base = {
        scope = module.resource_group["base"].id
        role_definition_names = [
          "Contributor",
          "User Access Administrator",
          "Key Vault Secrets Officer"
        ]
      }
      mgmt = {
        scope = module.resource_group["mgmt"].id
        role_definition_names = [
          "Contributor",
          "User Access Administrator",
          "Key Vault Secrets Officer"
        ]
      }
      core = {
        scope = module.resource_group["core"].id
        role_definition_names = [
          "Contributor",
          "User Access Administrator",
          "Key Vault Secrets Officer",
          "Azure Kubernetes Service RBAC Cluster Admin"
        ]
      }
    }
  }

  private_dns_zones = {
    kubernetes_cluster = {
      name = "privatelink.${var.location}.azmk8s.io"
    }
    mysql = {
      name = "privatelink.mysql.database.azure.com"
    }
  }

  network_security_rules = {
    agic = {
      GatewayManager = {
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_address_prefix      = "GatewayManager"
        source_port_range          = "*"
        destination_address_prefix = "*"
        destination_port_range     = "65200-65535"
      }
      ApplicationAll = {
        priority                   = 200
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_address_prefix      = "*"
        source_port_range          = "*"
        destination_address_prefix = "*"
        destination_port_ranges    = [80, 443]
      }
    }
  }

  combined_network_security_rules = merge(flatten([for nsg_key, nsg_rules in local.network_security_rules : [
    for rule_key, rule_value in nsg_rules : [
      { format("%s_%s", nsg_key, rule_key) = merge(rule_value, { "network_security_group_key" = nsg_key, "rule_key" = rule_key }) }
    ]
    ]
  ])...)
}

