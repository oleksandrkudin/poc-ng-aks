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

variable "subnet_id" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "jump" {
  type = object({
    sku                         = optional(string, "Standard_D2_v5")
    admin_username              = optional(string, "adminuser")
    platform_fault_domain_count = optional(number, 1)
  })
  default = {}
}