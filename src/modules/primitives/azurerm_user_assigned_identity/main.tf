module "naming" {
  source = "../naming_v2"

  base_name     = var.name
  resource_type = "azurerm_user_assigned_identity"
}

resource "azurerm_user_assigned_identity" "this" {
  name                = module.naming.name
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags
}

resource "azurerm_federated_identity_credential" "this" {
  for_each = var.federated_identity_credentials

  name                = each.key
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.this.id
  audience            = each.value.audience
  issuer              = each.value.issuer
  subject             = each.value.subject
}

module "role_mapping" {
  source = "../azurerm_role_mapping"

  principal_id  = azurerm_user_assigned_identity.this.principal_id
  role_mappings = var.role_mappings
}