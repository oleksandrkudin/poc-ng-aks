data "azurerm_client_config" "this" {}

data "http" "client_source_ip_address" {
  url = "https://ifconfig.me"
}
