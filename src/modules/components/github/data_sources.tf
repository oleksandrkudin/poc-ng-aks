data "github_repository" "this" {
  full_name = var.github_repository
}

data "azurerm_client_config" "this" {}

data "github_user" "this" {
  username = ""
}