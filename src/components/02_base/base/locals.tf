locals {
  component_short_name = "base"

  name       = format("%s-%s", module.naming.name, local.component_short_name)
  short_name = format("%s%s", module.naming.short_name, local.component_short_name)


  outbound_connectitity_public_ips = [for index in range(1, var.outbound_connectitity_public_ips.count + 1) : format("%02d", index)]

  resource_groups = {
    base = {}
    core = {}
    # k8s = {}
    # app = {}
  }


  resource_group_role_mappings = {
    Contributor = {
      base = {
        role_definition_names = [
          "Contributor",
          "Key Vault Secrets Officer"
        ]
      }
      core = {
        role_definition_names = [
          "Contributor",
          "Key Vault Secrets Officer"
        ]
      }
    }
  }
}