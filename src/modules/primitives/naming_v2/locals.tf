locals {
  location_short_name_map = {
    westeurope    = "weu"
    francecentral = "frc"
  }


  resource_type_abbreviation_map = {
    azurerm_resource_group                         = "rg"
    azurerm_virtual_network                        = "vnet"
    azurerm_network_security_group                 = "nsg"
    azurerm_mysql_flexible_server                  = "mysql"
    azurerm_user_assigned_identity                 = "id"
    azurerm_application_gateway                    = "agw"
    azurerm_kubernetes_cluster                     = "aks"
    azurerm_bastion_host                           = "bas"
    azurerm_orchestrated_virtual_machine_scale_set = "vmss"
    azurerm_linux_virtual_machine_scale_set        = "vmss"
    azurerm_network_interface                      = "nic"
    azurerm_monitor_autoscale_setting              = "autoscale"
    azurerm_nat_gateway                            = "ng"
    azurerm_public_ip                              = "pip"


    # Resources to not add resource type suffix.
    azurerm_key_vault        = null
    azurerm_storage_account  = null
    azurerm_key_vault_secret = null
  }

  resource_type_short_name = [
    "azurerm_key_vault",
    "azurerm_storage_account"
  ]

  name = join(contains(local.resource_type_short_name, coalesce(var.resource_type, "null")) ? "" : var.separator,
    compact([
      # product part
      contains(local.resource_type_short_name, coalesce(var.resource_type, "null")) ? replace(var.base_name, var.separator, "") : var.base_name,
      var.product,
      var.environment,
      var.location == null ? null : local.location_short_name_map[var.location],

      # physical, logical decomposition
      var.layer, # make sense only, if component have the same names across layers. Like logs storage account. But there is shared and dedicated resources for layer.
      var.component == var.layer ? null : var.component,

      # resource part
      var.resource_name,
      var.resource_type == null ? null : local.resource_type_abbreviation_map[var.resource_type], # resource type can play role of service or component name.
      var.count_index == null ? null : format("%02d", var.count_index),                           # resources created with count attribute

      # resource distingusher
      var.resource_version == null ? null : format("%02d", var.resource_version)
    ])
  )

  resource_type_conditions = {
    "azurerm_key_vault" = {
      condition     = length(local.name) >= 3 && length(local.name) <= 24
      error_message = "Key Vault name length must be between 3 and 24 chars."
    }
  }

}

# TODO: What is mechanism to pass resource version to module? What if many resources in module require it.

# TODO: think about layer. It implies layered architecture.

# TODO: If not resource but module has count attribute? count_index must be passed to module as attribute.
#    <base_name>-<count_index> = new base name. runner-01-vm, osdisk, disk, nic. Looks good.

output "name" {
  value = local.name

  precondition {
    condition     = contains(keys(local.resource_type_conditions), coalesce(var.resource_type, "null")) ? local.resource_type_conditions[var.resource_type].condition : true
    error_message = contains(keys(local.resource_type_conditions), coalesce(var.resource_type, "null")) ? local.resource_type_conditions[var.resource_type].error_message : ""
  }
}