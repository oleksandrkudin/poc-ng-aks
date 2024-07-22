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

variable "delegated_subnet_id" {
  type = string
}

variable "private_dns_zone_id" {
  type = string
}