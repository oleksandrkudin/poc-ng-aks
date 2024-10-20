remote_state {
  backend = "azurerm"
  generate = {
    path      = "azurerm_backend.tf"
    if_exists = "overwrite"
  }
  config = {
    use_azuread_auth = true
    use_oidc = true
    resource_group_name = "ok-dev-frc-tfstate-rg"
    storage_account_name = "okdevfrctfstate"
    container_name = "tfstate"
    key = format("%s/%s", path_relative_to_include(), "terraform.tfstate")
  }
}
