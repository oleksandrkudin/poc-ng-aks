output "tf_paths" {
  value = {
    "path.module"         = path.module
    "path.root"           = path.root
    "path.cwd"            = path.cwd
    "terraform.workspace" = terraform.workspace
  }
}

output "migrate_tfstate" {
  value = "az storage blob upload --auth-mode login -c ${var.terraform_state.container_name} --account-name ${module.terraform_state.name} --file terraform.tfstate --name ${var.deployment_short_name}-${local.component_short_name}.tfstate"
}