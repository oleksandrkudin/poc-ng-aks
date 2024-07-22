# Naming
module "naming" {
  source = "../../primitives/naming_v2"

  base_name = var.name
  component = "runner"
}

# Github runners 
module "github_runners" {
  source                      = "../../primitives/azurerm_flexible_linux_vmss"
  name                        = module.naming.name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  sku_name                    = var.github_runners.sku_name
  admin_username              = var.github_runners.admin_username
  platform_fault_domain_count = var.github_runners.platform_fault_domain_count
  subnet_id                   = var.subnet_id
  key_vault_id                = var.key_vault_id
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
        "script" = base64encode(templatefile("${path.root}/bootstrap.sh.tftpl", {
          disk_size_gb   = var.github_runners.data_disk_size_gb
          disk_lun       = var.github_runners.data_disk_lun
          RUNNER_CFG_PAT = var.github_pat
          runner_scope   = var.github_runners.agent.scope
          runner_group   = var.github_runners.agent.group
          labels         = "${var.environment},ubuntu-latest,ubuntu-22.04"
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
          default = 0
          minimum = 0
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

  tags = var.tags
}