variables {
  product_short_name     = "nmg"
  location_short_name    = "weu"
  environment_short_name = "dev"

  name       = "nmg-dev-weu"
  short_name = "nmgdevweu"
}

run "validate_name" {
  command = apply

  assert {
    condition     = output.name == var.name
    error_message = "Value name is not valid."
  }
}

run "validate_short_name" {
  command = plan

  assert {
    condition     = output.short_name == var.short_name
    error_message = "Value short_name is not valid."
  }
}