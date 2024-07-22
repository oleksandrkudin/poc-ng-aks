output "agic" {
  value = {
    name = module.agic.name
    id   = module.agic.id
    gateway_ip_configuration = {
      subnet_id = module.agic.gateway_ip_configuration[0].subnet_id
    }
  }
}

output "kubernetes_cluster" {
  value = {
    name                              = module.kubernetes_cluster.name
    id                                = module.kubernetes_cluster.id
    oidc_issuer_url                   = module.kubernetes_cluster.oidc_issuer_url
    node_resource_group_id            = module.kubernetes_cluster.node_resource_group_id
    resource_group_id                 = data.azurerm_resource_group.this.id
    role_based_access_control_enabled = module.kubernetes_cluster.role_based_access_control_enabled
  }
}