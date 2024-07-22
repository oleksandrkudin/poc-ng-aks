

# locals {
#   # terragrunt_remote_backend_path = "${get_repo_root()}/src/terragrunt/${get_env("ENVIRONMENT_SHORT_NAME")}_azurerm_backend.hcl"
# }

# TODO: do we need code to depend on configuration?
# Can terragrunt command accept file to be used as input?
# terragrunt pass all cli options to terraform, so -var-file=
inputs = jsondecode(read_tfvars_file("${get_repo_root()}/configuration/${get_env("ENVIRONMENT_SHORT_NAME")}.tfvars"))