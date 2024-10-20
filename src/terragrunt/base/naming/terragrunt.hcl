terraform {
  source = "../../..//modules/components/naming"
}

include "root" {
  path           = find_in_parent_folders()
  merge_strategy = "deep"
}

include "backend" {
  path = find_in_parent_folders("azurerm_backend.hcl")
}
