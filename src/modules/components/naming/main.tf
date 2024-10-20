# Base name
module "naming" {
  source = "../../primitives/naming_v2"

  product     = var.product
  location    = var.location
  environment = var.environment
}

# Base tags
module "tags" {
  source = "../../primitives/tags"

  product_name     = var.product
  environment_name = var.environment
}