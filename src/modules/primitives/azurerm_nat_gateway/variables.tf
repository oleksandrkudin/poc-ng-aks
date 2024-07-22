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

variable "sku_name" {
  description = "The SKU which should be used."
  type        = string
  default     = "Standard"
}

variable "idle_timeout_in_minutes" {
  description = "The idle timeout which should be used in minutes."
  type        = number
  default     = null
}

variable "zones" {
  description = "A list of Availability Zones in which this NAT Gateway should be located."
  type        = list(string)
  default     = null
}

variable "public_ip_ids" {
  description = "Map of public ip address id."
  type        = map(string)
}

variable "subnet_ids" {
  description = "Map of subnet ids."
  type        = map(string)
}