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

variable "allocation_method" {
  description = "The allocation method for IP address. Possible values are Static, Dynamic."
  type        = string
}

variable "zones" {
  description = "List of Availability Zones to allocate the Public IP in."
  type        = list(string)
  default     = null
}

variable "ddos_protection_mode" {
  description = "The DDoS protection mode of the public IP. Possible values are Disabled, Enabled, VirtualNetworkInherited. Defaults to VirtualNetworkInherited."
  type        = string
  default     = null
}

variable "ddos_protection_plan_id" {
  description = "The ID of DDoS protection plan associated with the public IP."
  type        = string
  default     = null
}

variable "domain_name_label" {
  description = "Label for the Domain Name. It is used to make up the FQDN."
  type        = string
  default     = null
}

variable "edge_zone" {
  description = "Specifies the Edge Zone within the Azure Region where this Public IP should exist."
  type        = string
  default     = null
}

variable "idle_timeout_in_minutes" {
  description = "Specifies the timeout for the TCP idle connection. The value can be set between 4 and 30 minutes."
  type        = number
  default     = null
}

variable "ip_tags" {
  description = "A mapping of IP tags to assign to the public IP."
  type        = map(string)
  default     = null
}

variable "ip_version" {
  description = "The IP Version to use, IPv6 or IPv4."
  type        = string
  default     = null
}

variable "public_ip_prefix_id" {
  description = "If specified then public IP address allocated will be provided from the public IP prefix resource."
  type        = string
  default     = null
}

variable "reverse_fqdn" {
  description = "The fully qualified domain name that resolves to this public IP address."
  type        = string
  default     = null
}

variable "sku" {
  description = "The SKU of the Public IP. Accepted values are Basic and Standard."
  type        = string
  default     = null
}

variable "sku_tier" {
  description = "The SKU Tier that should be used for the Public IP. Possible values are Regional and Global."
  type        = string
  default     = null
}