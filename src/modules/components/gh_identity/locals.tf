locals {
  roles = ["Owner", "Contributor", "Reader"]

  combined_role_mappings = { for role in local.roles : role => merge(flatten([
    for role_mappings in values(var.all_role_mappings) : try(role_mappings[role], {})
  ])...) }
}