########################################################
# Global settinngs
########################################################

variable "name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "location" {
  description = "Azure location."
  type        = string
}

variable "resource_group_base_name" {
  type = string
}


########################################################
# Component specific settinngs
########################################################

variable "zones" {
  description = "List of Availability Zones for zonal resources."
  type        = list(string)
}

# Networking
variable "networking" {
  description = "Networking configuration."
  type = object({
    name          = optional(string)
    address_space = list(string)
    subnets = object({
      runner = object({
        name             = optional(string)
        address_prefixes = list(string)
      })
      bastion = object({
        name                          = optional(string)
        address_prefixes              = list(string)
        create_network_security_group = optional(bool, false)
      })
      kubernetes_cluster = object({
        name             = optional(string)
        address_prefixes = list(string)
      })
      jump = object({
        name             = optional(string)
        address_prefixes = list(string)
      })
      agic = object({
        name             = optional(string)
        address_prefixes = list(string)
      })
      private_endpoint = object({
        name             = optional(string)
        address_prefixes = list(string)
      })
      mysql = object({
        name             = optional(string)
        address_prefixes = list(string)
        delegations = optional(map(object({
          name = optional(string)
          service_delegation = object({
            name    = string
            actions = optional(list(string))
          })
          })), { mysql = {
          service_delegation = {
            name    = "Microsoft.DBforMySQL/flexibleServers"
            actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
          }
        } })
      })
    })
  })
}

# Outbound connectivity
variable "outbound_connectitity_public_ips" {
  description = "Map of public ip addresses for outbound connectivity."
  type = object({
    count             = optional(number, 1)
    allocation_method = optional(string, "Static")
    sku               = optional(string, "Standard")
  })
  default = {}
}
