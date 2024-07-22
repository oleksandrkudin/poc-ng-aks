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

variable "zones" {
  description = "List of Availability Zones for zonal resources."
  type        = list(string)
}

variable "subnet_id" {
  type = string
}

variable "inbound_mgmt_connectitity" {
  type = object({
    allocation_method = optional(string, "Static")
    sku               = optional(string, "Standard")
  })
  default = {}
}