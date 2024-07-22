# TODO: if required, output backend configuration

output "id" {
  value = module.terraform_state.id
}

output "role_mappings" {
  value = local.role_mappings
}