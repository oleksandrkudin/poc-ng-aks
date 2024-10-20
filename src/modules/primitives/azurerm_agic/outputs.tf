output "name" {
  value = azurerm_application_gateway.this.name
}

output "id" {
  value = azurerm_application_gateway.this.id
}

output "gateway_ip_configuration" {
  value = [for gateway_ip_configuration in azurerm_application_gateway.this.gateway_ip_configuration : { subnet_id = gateway_ip_configuration.subnet_id }]
}