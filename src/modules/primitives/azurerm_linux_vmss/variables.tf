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

variable "key_vault_id" {
  description = "Azure Key Vault id to save ssh private key."
  type        = string
}

variable "instances" {
  description = "The number of Virtual Machines in the Virtual Machine Scale Set."
  type        = number
  default     = null
}

variable "platform_fault_domain_count" {
  description = "Number of fault domains that are used by this Virtual Machine Scale Set."
  type        = number
}

variable "sku" {
  description = "The name of the SKU to be used by this Virtual Machine Scale Set."
  type        = string
}

variable "encryption_at_host_enabled" {
  description = "Whether disks attached to this Virtual Machine Scale Set be encrypted."
  type        = bool
  default     = null
}

variable "zones" {
  description = "Specifies a list of Availability Zones across which the Virtual Machine Scale Set will create instances."
  type        = list(string)
  default     = null
}

variable "subnet_id" {
  description = "Subnet id to push Virtual Machine Scale Set instances into."
  type        = string
}

variable "admin_username" {
  description = "Admin username."
  type        = string
  default     = "adminuser"
}

variable "os_disk" {
  description = "OS disk configuration."
  type = object({
    caching                   = string
    storage_account_type      = string
    disk_size_gb              = optional(string)
    write_accelerator_enabled = optional(bool)
  })
}

variable "source_image_reference" {
  description = "Source image reference configuration."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = null
}

variable "source_image_id" {
  description = "The ID of an Image which each Virtual Machine in this Scale Set should be based on. Possible Image ID types include Image IDs, Shared Image IDs, Shared Image Version IDs, Community Gallery Image IDs, Community Gallery Image Version IDs, Shared Gallery Image IDs and Shared Gallery Image Version IDs."
  type        = string
  default     = null
}

variable "data_disks" {
  description = "Map of data disk configuration objects."
  type = map(object({
    caching              = string
    storage_account_type = string
    disk_size_gb         = optional(string)
    lun                  = optional(number)
  }))
  default = {}
}

variable "extensions" {
  description = "Map of extension configuration objects. Protected_settings is not included."
  type = map(object({
    name                 = string
    publisher            = string
    type                 = string
    type_handler_version = string
    settings             = optional(string)
  }))
  default = {}
}

variable "extension_protected_settings" {
  description = "Map of protected_settings configuration objects for extensions."
  type = map(object({
    protected_settings = optional(string)
  }))
  sensitive = true
  default   = {}
}

variable "autoscale_setting" {
  description = "Autoscale setting."
  type = object({
    enabled = optional(bool)
    profiles = map(object({
      name = optional(string)
      capacity = object({
        default = number
        maximum = number
        minimum = number
      })
      rules = map(object({
        metric_trigger = object({
          metric_name              = string
          operator                 = string
          statistic                = string
          time_aggregation         = string
          time_grain               = string
          time_window              = string
          threshold                = number
          divide_by_instance_count = optional(bool)
        })
        scale_action = object({
          cooldown  = string
          direction = string
          type      = string
          value     = string
        })
      }))
    }))
  })
  default = null
}