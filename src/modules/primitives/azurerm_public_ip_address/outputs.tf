output "name" {
  description = "Public IP address resource name."
  value       = azurerm_public_ip.this.name
}

output "id" {
  description = "Public IP address resource id."
  value       = azurerm_public_ip.this.id
}
