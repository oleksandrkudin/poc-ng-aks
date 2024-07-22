variable "name" {
  description = "Name of the resource."
  type        = string
}

variable "location" {
  description = "Azure location."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "tags" {
  description = "Azure resource tags."
  type        = map(string)
  default     = null
}

variable "address_space" {
  description = "List of address spaces that is used the virtual network."
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnet objects."
  type = map(object({
    name                          = optional(string)
    address_prefixes              = list(string)
    create_network_security_group = optional(bool, true)
    delegations = optional(map(object({
      name = optional(string)
      service_delegation = object({
        name    = string
        actions = optional(list(string))
      })
    })), {})
  }))
}


variable "private_dns_zones" {
  description = "Map of private DNS zones objects."
  type = map(object({
    name = optional(string)
    virtual_network_link = optional(object({
      registration_enabled = optional(bool)
    }), {})
  }))
  default = {}
}
