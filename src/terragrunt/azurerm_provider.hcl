generate "azurerm_provider" {
  path      = "azurerm_provider.tf"
  if_exists = "overwrite"
  contents  = <<-EOT
    provider "azurerm" {
      storage_use_azuread = true
      features {
        resource_group {
          prevent_deletion_if_contains_resources = false
        }
      }
    }
  EOT
}