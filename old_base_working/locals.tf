locals {
  component_short_name = "init"

  name       = format("%s-%s", module.naming.name, local.component_short_name)
  short_name = format("%s%s", module.naming.short_name, local.component_short_name)

  subnet_name = "runners"

  data_disk_lun = 1

  outbound_connectitity_public_ips = [for index in range(1, var.outbound_connectitity_public_ips.count + 1) : format("%02d", index)]

  # TODO: How many resource groups do we need? Resource group per layer?    
  resource_groups = {
    init       = {}
    platform   = {}
    kubernetes = {}
    app        = {}
  }

  role_mappings = {
    Contributor = {
      init = {
        role_definition_names = [
          "Contributor",
          "Key Vault Secrets Officer"
        ]
      }
      platform = {}
    }
  }

}