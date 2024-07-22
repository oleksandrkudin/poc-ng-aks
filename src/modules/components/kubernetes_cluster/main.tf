# Naming
module "naming" {
  source = "../../primitives/naming_v2"

  base_name = var.name
  component = "kube"
}

# Kubernetes cluster
module "kubernetes_cluster" {
  source              = "../../primitives/azurerm_linux_kubernetes_cluster"
  name                = module.naming.name
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_id        = var.key_vault_id
  kubernetes_version  = var.kubernetes_version
  admin_username      = var.admin_username
  network_profile     = var.network_profile
  default_node_pool   = var.default_node_pool
  # private_cluster_enabled = true
  # private_dns_zone_id = var.private_dns_zone_id
  # dns_prefix_private_cluster = module.naming.name
  dns_prefix                = module.naming.name
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  local_account_disabled = true
  zones                  = var.zones

  azure_active_directory_role_based_access_control = {
    tenant_id          = data.azurerm_client_config.this.tenant_id
    azure_rbac_enabled = true
  }

  key_vault_secrets_provider = {
    secret_rotation_enabled = true
  }

  tags = var.tags
}

# Application Gateway for ingress controller
module "agic_pip_naming" {
  source = "../../primitives/naming_v2"

  base_name = module.naming.name
  resource_name = "app-shared"
}

module "agic_pip" {
  source              = "../../primitives/azurerm_public_ip_address"
  name                = module.agic_pip_naming.name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.zones
  tags                = var.tags
}

module "agic" {
  source              = "../../primitives/azurerm_agic"
  name                = module.naming.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku = {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }
  zones = var.zones


  gateway_ip_configurations = {
    main = {
      name      = "main"
      subnet_id = var.agic.subnet_id
    }
  }

  frontend_ip_configurations = {
    main = {
      name                 = "main"
      public_ip_address_id = module.agic_pip.id
    }
  }

  frontend_ports = {
    http = {
      name = "http"
      port = 80
    }
    https = {
      name = "https"
      port = 443
    }
  }
}
