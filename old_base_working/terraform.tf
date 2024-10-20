terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # TODO: Consider setting specific provider version
      # version = "value"
    }
    time = {
      source = "hashicorp/time"
    }
    tls = {
      source = "hashicorp/tls"
    }
    http = {
      source = "hashicorp/http"
    }
  }

}