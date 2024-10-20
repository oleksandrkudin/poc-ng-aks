
# Naming
module "naming" {
  source = "../../primitives/naming_v2"

  base_name = var.name
  component = "k8sapp"
}

# AGIC
module "k8s_agic" {
  source              = "../../primitives/k8s_agic"
  create_namespace    = true
  name                = module.naming.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subscription_id     = data.azurerm_client_config.this.subscription_id
  kubernetes_cluster  = var.kubernetes_cluster
  agic                = var.agic
  tags                = var.tags
}