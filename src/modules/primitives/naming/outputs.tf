locals {
  # To manage item order in one place.
  name_items = [var.product_short_name, var.environment_short_name, var.location_short_name]

  name       = join("-", local.name_items)
  short_name = join("", local.name_items)
}

output "name" {
  description = "Name for resources that do not have limit for name length."
  value       = local.name
}

output "short_name" {
  description = "Name for resources that do have limit for name length. Examples: Key Vault, Storage Account."
  value       = local.short_name
}