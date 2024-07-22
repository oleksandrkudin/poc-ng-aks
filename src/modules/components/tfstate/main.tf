# Naming
module "naming" {
  source = "../../primitives/naming_v2"

  base_name     = var.name
  component     = "tfstate"
}

# Resource group
module "resource_group" {
  source = "../../primitives/azurerm_resource_group"

  name     = module.naming.name
  location = var.location
  tags     = var.tags
}

# Terraform state storage
module "terraform_state" {
  source                          = "../../primitives/azurerm_storage_account"
  name                            = module.naming.name
  resource_group_name             = module.resource_group.name
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

  tags = var.tags
}

# Current user should have access to terraform state storage to provision next components.
resource "azurerm_role_assignment" "this" {
  name                 = local.role_assignment_name
  role_definition_name = "Storage Blob Data Contributor"
  scope                = module.terraform_state.id
  principal_id         = data.azurerm_client_config.this.object_id
}

# Create azurerm backend configuration for Terragrunt
resource "local_file" "terragrunt_azurerm_backend" {
  content  = <<-EOT
    remote_state {
      backend = "azurerm"
      generate = {
        path      = "azurerm_backend.tf"
        if_exists = "overwrite"
      }
      config = {
        use_azuread_auth = true
        use_oidc = true
        resource_group_name = "${module.resource_group.name}"
        storage_account_name = "${module.storage_account_naming.name}"
        container_name = "${local.containers.tfstate.name}"
        key = format("%s/%s", path_relative_to_include(), "terraform.tfstate")
      }
    }
  EOT
  filename = var.terragrunt_remote_backend_path
}