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

variable "resource_group_name" {
  type = string
}

########################################################
# Component specific settinngs
########################################################

variable "zones" {
  description = "List of Availability Zones for zonal resources."
  type        = list(string)
}

variable "key_vault_id" {
  type = string
}

variable "admin_username" {
  type    = string
  default = "adminuser"
}

variable "kubernetes_version" {
  type    = string
  default = "1.28.9"
}

variable "network_profile" {
  type = object({
    network_plugin = optional(string, "azure")
    network_policy = optional(string, "calico")
    outbound_type  = optional(string)
  })
  default = {}
}

variable "default_node_pool" {
  type = object({
    name                        = optional(string, "default")
    vm_size                     = optional(string, "Standard_D2s_v5")
    temporary_name_for_rotation = optional(string, "temp")
    vnet_subnet_id              = optional(string)
    enable_auto_scaling         = optional(bool)
    max_count                   = optional(number)
    min_count                   = optional(number)
    node_count                  = optional(number, 1)
  })
  default = {}
}

variable "private_dns_zone_id" {
  type = string
}

########################################################
# Application gateway
########################################################

variable "agic" {
  description = "Application Gateway configuration."
  type = object({
    subnet_id = string
  })
}
