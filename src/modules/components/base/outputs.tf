output "tf_paths" {
  value = {
    "path.module"         = path.module
    "path.root"           = path.root
    "path.cwd"            = path.cwd
    "terraform.workspace" = terraform.workspace
  }
}

# output "migrate_tfstate" {
#   value = "az storage blob upload --auth-mode login -c ${var.terraform_state.container_name} --account-name ${module.terraform_state.name} --file terraform.tfstate --name ${var.environment_short_name}-${local.component_short_name}.tfstate"
# }

output "resource_groups" {
  value = { for key in keys(local.resource_groups) : key =>
    {
      name = module.resource_group[key].name
      id   = module.resource_group[key].id
    }
  }
}

output "role_mappings" {
  value = local.role_mappings
}

output "subnets" {
  value = module.networking.subnets
}

output "key_vaults" {
  value = {
    layer_shared_public = {
      name = module.shared_public_key_vault.name
      id   = module.shared_public_key_vault.id
    }
  }
}

output "private_dns_zones" {
  value = module.networking.private_dns_zones
}