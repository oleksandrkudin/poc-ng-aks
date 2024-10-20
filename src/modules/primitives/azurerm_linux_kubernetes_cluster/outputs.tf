output "name" {
  value = azurerm_kubernetes_cluster.this.name
}

output "id" {
  value = azurerm_kubernetes_cluster.this.id
}

output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "node_resource_group_id" {
  value = azurerm_kubernetes_cluster.this.node_resource_group_id
}

output "role_based_access_control_enabled" {
  value = azurerm_kubernetes_cluster.this.role_based_access_control_enabled
}
