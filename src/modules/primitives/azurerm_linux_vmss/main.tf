module "naming" {
  source = "../naming_v2"

  base_name     = var.name
  resource_type = "azurerm_linux_virtual_machine_scale_set"
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

module "vmss_child_resource_naming" {
  for_each = {
    ssh_private_key_secret = {
      resource_name = "ssh-private-key"
      resource_type = "azurerm_key_vault_secret"
    }
    network_interface = {
      resource_type = "azurerm_network_interface"
    }
    autoscale_setting = {
      resource_type = "azurerm_monitor_autoscale_setting"
    }
  }

  source = "../naming_v2"

  base_name     = module.naming.name
  resource_name = try(each.value.resource_name, null)
  resource_type = each.value.resource_type
}

resource "azurerm_key_vault_secret" "ssh_private_key" {
  name         = module.vmss_child_resource_naming["ssh_private_key_secret"].name
  key_vault_id = var.key_vault_id
  value        = tls_private_key.ssh.private_key_openssh
  tags         = var.tags
}

resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                        = module.naming.name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  admin_username              = var.admin_username
  instances                   = var.instances
  platform_fault_domain_count = var.platform_fault_domain_count
  sku                         = var.sku
  encryption_at_host_enabled  = var.encryption_at_host_enabled
  zones                       = var.zones

  network_interface {
    name    = module.vmss_child_resource_naming["network_interface"].name
    primary = true
    ip_configuration {
      name      = "default"
      primary   = true
      subnet_id = var.subnet_id
    }
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = trimspace(tls_private_key.ssh.public_key_openssh)
  }

  dynamic "os_disk" {
    for_each = var.os_disk == null ? [] : [1]

    content {
      caching                   = var.os_disk.caching
      storage_account_type      = var.os_disk.storage_account_type
      disk_size_gb              = var.os_disk.disk_size_gb
      write_accelerator_enabled = var.os_disk.write_accelerator_enabled
    }
  }

  dynamic "source_image_reference" {
    for_each = var.source_image_reference == null ? [] : [1]

    content {
      publisher = var.source_image_reference.publisher
      offer     = var.source_image_reference.offer
      sku       = var.source_image_reference.sku
      version   = var.source_image_reference.version
    }
  }

  source_image_id = var.source_image_id

  dynamic "data_disk" {
    for_each = var.data_disks

    content {
      caching              = data_disk.value.caching
      storage_account_type = data_disk.value.storage_account_type
      disk_size_gb         = data_disk.value.disk_size_gb
      lun                  = data_disk.value.lun
    }
  }

  # Extension created with azurerm_virtual_machine_scale_set_extension is not added to virtual machine by default. It exists only on VMSS resource. 
  dynamic "extension" {
    for_each = var.extensions

    content {
      name                 = extension.value.name
      publisher            = extension.value.publisher
      type                 = extension.value.type
      type_handler_version = extension.value.type_handler_version
      settings             = extension.value.settings
      protected_settings   = var.extension_protected_settings[extension.key].protected_settings
    }
  }

  tags = var.tags
}

resource "azurerm_monitor_autoscale_setting" "this" {
  count               = var.autoscale_setting == null ? 0 : 1
  name                = module.vmss_child_resource_naming["autoscale_setting"].name
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.this.id
  enabled             = var.autoscale_setting.enabled

  dynamic "profile" {
    for_each = var.autoscale_setting.profiles

    content {
      name = coalesce(profile.value.name, profile.key)

      capacity {
        default = profile.value.capacity.default
        maximum = profile.value.capacity.maximum
        minimum = profile.value.capacity.minimum
      }

      dynamic "rule" {
        for_each = profile.value.rules

        content {
          metric_trigger {
            metric_name              = rule.value.metric_trigger.metric_name
            metric_resource_id       = azurerm_linux_virtual_machine_scale_set.this.id
            operator                 = rule.value.metric_trigger.operator
            statistic                = rule.value.metric_trigger.statistic
            time_aggregation         = rule.value.metric_trigger.time_aggregation
            time_grain               = rule.value.metric_trigger.time_grain
            time_window              = rule.value.metric_trigger.time_window
            threshold                = rule.value.metric_trigger.threshold
            metric_namespace         = "microsoft.compute/virtualmachinescalesets"
            divide_by_instance_count = rule.value.metric_trigger.divide_by_instance_count
          }

          scale_action {
            cooldown  = rule.value.scale_action.cooldown
            direction = rule.value.scale_action.direction
            type      = rule.value.scale_action.type
            value     = rule.value.scale_action.value
          }
        }
      }
    }
  }

  tags = var.tags
}