module "naming" {
  source = "../naming_v2"

  base_name     = var.name
  resource_type = "azurerm_application_gateway"
}

resource "azurerm_application_gateway" "this" {
  name                = module.naming.name
  location            = var.location
  resource_group_name = var.resource_group_name
  zones               = var.zones
  sku {
    name     = var.sku.name
    tier     = var.sku.tier
    capacity = var.sku.capacity
  }

  dynamic "gateway_ip_configuration" {
    for_each = var.gateway_ip_configurations

    content {
      name      = gateway_ip_configuration.value.name
      subnet_id = gateway_ip_configuration.value.subnet_id
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations

    content {
      name                 = frontend_ip_configuration.value.name
      public_ip_address_id = frontend_ip_configuration.value.public_ip_address_id
    }
  }

  dynamic "frontend_port" {
    for_each = var.frontend_ports

    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  # Just to create application gateway, sub-resources are managed by AGIC.
  http_listener {
    name                           = "default"
    frontend_ip_configuration_name = values(var.frontend_ip_configurations)[0].name
    frontend_port_name             = values(var.frontend_ports)[0].name
    protocol                       = "Http"
  }

  # Just to create application gateway, sub-resources are managed by AGIC.
  backend_address_pool {
    name = "default"
  }

  # Just to create application gateway, sub-resources are managed by AGIC.
  backend_http_settings {
    name                  = "default"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
  }

  # Just to create application gateway, sub-resources are managed by AGIC.
  request_routing_rule {
    priority                   = 5000
    name                       = "default"
    rule_type                  = "Basic"
    http_listener_name         = "default"
    backend_http_settings_name = "default"
    backend_address_pool_name  = "default"
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      http_listener,
      backend_address_pool,
      backend_http_settings,
      probe,
      request_routing_rule
    ]
  }
}
