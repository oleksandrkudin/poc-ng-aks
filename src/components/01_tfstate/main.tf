# Base name
module "naming" {
  source = "../../modules/naming"

  product_short_name    = var.product_short_name
  location_short_name   = var.location_short_name
  deployment_short_name = var.deployment_short_name
}

# Base tags
module "tags" {
  source = "../../modules/tags"

  product_name     = var.product_name
  environment_name = var.environment_name
}

# Resource group
resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location
  tags     = module.tags.tags
}

# Terraform state storage
module "terraform_state" {
  source                          = "../../modules/azurerm_storage_account"
  name                            = local.storage_account_name
  resource_group_name             = azurerm_resource_group.this.name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS" # Production environment should have ZRS.
  account_kind                    = "StorageV2"
  shared_access_key_enabled       = false
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = true

  network_rules = {
    default_action = "Deny"
    ip_rules = concat([
      trimspace(data.http.client_source_ip_address.response_body)],
      var.terraform_state.extra_ip_rules
    )
  }

  containers = local.containers

  tags = module.tags.tags
}

# Current user should have access to terraform state storage to provision next components.
resource "azurerm_role_assignment" "this" {
  name                 = local.role_assignment_name
  role_definition_name = "Storage Blob Data Contributor"
  scope                = module.terraform_state.id
  principal_id         = data.azurerm_client_config.this.object_id
}