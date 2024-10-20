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

variable "environment" {
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

variable "github_pat" {
  description = "GitHub PAT token used to get registration token for runners onboarding. Github repo access scope is required for token."
  type        = string
  sensitive   = true
}

variable "github_runners" {
  description = "GitHub runners configuration."
  type = object({
    sku_name                    = optional(string, "Standard_D2_v5")
    platform_fault_domain_count = optional(number, 1)
    admin_username              = optional(string, "adminuser")
    data_disk_size_gb           = optional(string, "64")
    data_disk_lun               = optional(number, 1)
    subnet_key                  = string
    agent = object({
      scope = string
      group = optional(string, "")
      count = optional(number, 2)
    })
  })
}

