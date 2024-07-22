output "tags" {
  description = "Common tags for all product resources."
  value = {
    product_name     = var.product_name
    environment_name = var.environment_name
  }
}