terraform {
  source = "../../..//modules/components/naming"
}

include "root" {
  path           = find_in_parent_folders()
  merge_strategy = "deep"
}

remote_state {
  backend = "local"
  generate = {
    path      = "local_backend.tf"
    if_exists = "overwrite"
  }
  config = {
    path = "/tmp/naming_terraform.tfstate"
  }
}