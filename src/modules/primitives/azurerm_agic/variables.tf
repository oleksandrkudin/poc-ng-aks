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

variable "zones" {
  description = "Specifies a list of Availability Zones across which the Virtual Machine Scale Set will create instances."
  type        = list(string)
  default     = null
}

variable "sku" {
  description = "The SKU of Application Gateway."
  type = object({
    name     = string
    tier     = string
    capacity = number
  })
}

variable "gateway_ip_configurations" {
  description = "Map of gateway ip configuration objects."
  type = map(object({
    name      = string
    subnet_id = string
  }))
}

variable "frontend_ip_configurations" {
  description = "Map of frontend ip configuration objects."
  type = map(object({
    name                 = string
    public_ip_address_id = string
  }))
}

variable "frontend_ports" {
  description = "Map of frontend port objects."
  type = map(object({
    name = string
    port = number
  }))
}