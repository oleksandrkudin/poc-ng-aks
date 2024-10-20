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

# Main resource group
resource "azurerm_resource_group" "this" {
  name     = format("%s-%s", local.name, "rg")
  location = var.location
  tags     = module.tags.tags
}

# Roles's assignments
# TODO: make sense only during first manual run. Must be disabled when User-assigned identity is used.
#     What if somebody run it from local PC?
resource "azurerm_role_assignment" "rg" {
  for_each = {
    # sa_contributor = "Storage Account Contributor"  # TODO: This is issue?
    # sa_blob_data_contributor = "Storage Blob Data Contributor"
    # sa_file_data_privileged_contributor = "Storage File Data Privileged Contributor"
    # sa_queue_data_contributor = "Storage Queue Data Contributor"
    # sa_table_data_contributor = "Storage Table Data Contributor"
    # sa_file_data_smb_share_ontributor = "Storage File Data SMB Share Contributor"
    kv_secrets_officer = "Key Vault Secrets Officer"
  }

  role_definition_name = each.value
  principal_id         = data.azurerm_client_config.this.object_id
  scope                = azurerm_resource_group.this.id
}

resource "time_sleep" "role_assignment_rg" {
  create_duration = "1m"

  depends_on = [azurerm_role_assignment.rg]
}

# Base Networking
module "networking" {
  source              = "../../modules/azurerm_networking"
  name                = format("%s-%s", local.name, "vnet")
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  address_space       = var.networking.address_space
  subnets             = var.networking.subnets
  tags                = module.tags.tags
}

# Outbound connectivity
locals {
  outbound_connectitity_public_ip = toset([for index in range(1, var.outbound_connectitity_public_ips.count + 1) : format("%02d", index)])
}

resource "azurerm_public_ip" "outbound_connectitity" {
  for_each = local.outbound_connectitity_public_ip

  name                = format("%s-%s-%s", local.name, "outbound-pip", each.value)
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = var.outbound_connectitity_public_ips.allocation_method
  sku                 = var.outbound_connectitity_public_ips.sku
  zones               = var.zones
  tags                = module.tags.tags
}

module "nat_gateway" {
  source              = "../../modules/azurerm_nat_gateway"
  name                = format("%s-%s", local.name, "ng")
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  public_ip_ids       = { for key in local.outbound_connectitity_public_ip : key => azurerm_public_ip.outbound_connectitity[key].id }
  subnet_ids          = { for key, value in module.networking.subnets : key => value.id }
  zones               = var.zones
  tags                = module.tags.tags
}

# Terraform state storage
module "terraform_state" {
  source                          = "../../modules/azurerm_storage_account"
  name                            = format("%s%s%s", local.short_name, "tfstate", "sa")
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

  containers = {
    tfstate = {
      name = var.terraform_state.container_name
    }
  }

  tags = module.tags.tags
}

# Secrets storage
module "service_shared_public_key_vault" {
  source                     = "../../modules/azurerm_key_vault"
  name                       = format("%s%s%s", local.short_name, "shrpub", "kv")
  resource_group_name        = azurerm_resource_group.this.name
  location                   = var.location
  tenant_id                  = data.azurerm_client_config.this.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
  enable_rbac_authorization  = true
  tags                       = module.tags.tags
}

# GitHub runners
module "github_runners" {
  source                      = "../../modules/azurerm_flexible_linux_vmss"
  name                        = format("%s-%s-%s", local.name, "github-runners", "vmss")
  resource_group_name         = azurerm_resource_group.this.name
  location                    = var.location
  sku_name                    = var.github_runners.sku_name
  admin_username              = var.github_runners.admin_username
  platform_fault_domain_count = var.github_runners.platform_fault_domain_count
  subnet_id                   = module.networking.subnets[var.github_runners.subnet_key].id
  key_vault_id                = module.service_shared_public_key_vault.id
  zones                       = var.zones

  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  data_disks = {
    "runners" = {
      caching              = "ReadOnly"
      disk_size_gb         = var.github_runners.data_disk_size_gb
      lun                  = var.github_runners.data_disk_lun
      storage_account_type = "Standard_LRS"
    }
  }

  extensions = {
    github_runners_bootstrap = {
      name                 = "github_runners_bootstrap"
      publisher            = "Microsoft.Azure.Extensions"
      type                 = "CustomScript"
      type_handler_version = "2.1"
    }
  }

  extension_protected_settings = {
    github_runners_bootstrap = {
      protected_settings = jsonencode({
        "script" = base64encode(templatefile("${path.root}/github_runners_bootstrap.sh.tftpl", {
          disk_size_gb   = var.github_runners.data_disk_size_gb
          disk_lun       = var.github_runners.data_disk_lun
          RUNNER_CFG_PAT = var.github_pat
          runner_scope   = var.github_runners.agent.scope
          runner_group   = var.github_runners.agent.group
          labels         = "ubuntu-latest,ubuntu-22.04"
          runner_count   = var.github_runners.agent.count
          runner_user    = var.github_runners.admin_username
        }))
      })
    }
  }

  autoscale_setting = {
    profiles = {
      default_profile = {
        capacity = {
          default = 1
          minimum = 1
          maximum = 3
        }

        rules = {
          scaleout = {
            metric_trigger = {
              metric_name      = "Percentage CPU"
              time_grain       = "PT1M"
              statistic        = "Average"
              time_window      = "PT10M"
              time_aggregation = "Average"
              operator         = "GreaterThan"
              threshold        = 75
            }

            scale_action = {
              direction = "Increase"
              type      = "ChangeCount"
              value     = "1"
              cooldown  = "PT10M"
            }
          }

          scalein = {
            metric_trigger = {
              metric_name      = "Percentage CPU"
              time_grain       = "PT1M"
              statistic        = "Average"
              time_window      = "PT10M"
              time_aggregation = "Average"
              operator         = "LessThan"
              threshold        = 15
            }

            scale_action = {
              direction = "Decrease"
              type      = "ChangeCount"
              value     = "1"
              cooldown  = "PT5M"
            }
          }
        }
      }
    }

  }

  tags = module.tags.tags

  depends_on = [
    time_sleep.role_assignment_rg,
    module.nat_gateway
  ]
}

# GitHub repository environment identity
module "github_repository_environment_identity" {
  source = "../../modules/azurerm_user_assigned_identity"

  name                = format("%s-%s", local.name, "id")
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  federated_identity_credentials = {
    github_repository_environment = {
      audience = ["api://AzureADTokenExchange"]
      issuer   = "https://token.actions.githubusercontent.com"
      subject  = "repo:${var.github_repository}:environment:${var.deployment_short_name}"
    }
  }
  tags = module.tags.tags
}

# TODO: roles's assignments for github_repository_environment_identity.
#    it should be done during initial provisioning by the person who has owner role.
#    Owner can assign role for github_repository_environment_identity to resource group.
#    But if necessary to add new resource group, github_repository_environment_identity cannot do that. Necessary to run from local PC.
#    If github_repository_environment_identity creates resource, does it become Owner for this resource group?
# Idea is to limit access for identity to only resource groups that identity created.
