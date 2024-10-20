########################################################
# Global settinngs
########################################################

variable "product_name" {
  description = "Product name."
  type        = string
}

variable "environment_name" {
  description = "Deployment environment name."
  type        = string
}

variable "product_short_name" {
  description = "Product short name. Length limit is three chars."
  type        = string

  validation {
    condition     = length(var.product_short_name) <= 3
    error_message = "The variable value length must be less or equal to three."
  }
}

variable "location_short_name" {
  description = "Azure location short name. Length limit is three chars."
  type        = string

  validation {
    condition     = length(var.location_short_name) <= 3
    error_message = "The variable value length must be less or equal to three."
  }
}

variable "deployment_short_name" {
  description = "Deployment instance short name. Length limit is three chars. Can be used environment short name value."
  type        = string
  default     = null

  validation {
    condition     = var.deployment_short_name == null ? true : length(var.deployment_short_name) <= 3
    error_message = "The variable value length must be less or equal to three."
  }
}

variable "location" {
  description = "Azure location."
  type        = string
}

variable "zones" {
  description = "List of Availability Zones for zonal resources."
  type        = list(string)
}

########################################################
# Secrets to be passed via environment or cli
########################################################

variable "github_pat" {
  description = "GitHub PAT token used to get registration token for runners onboarding. Github repo access scope is required for token."
  type        = string
  sensitive   = true
}

########################################################
# Component specific settinngs
########################################################

# Networking
variable "networking" {
  description = "Networking configuration."
  type = object({
    name          = optional(string)
    address_space = list(string)
    subnets = map(object({
      name             = optional(string)
      address_prefixes = list(string)
    }))
  })
}

# Outbound connectivity
variable "outbound_connectitity_public_ips" {
  description = "Map of public ip addresses for outbound connectivity."
  type = object({
    count             = optional(number, 1)
    allocation_method = optional(string, "Static")
    sku               = optional(string, "Standard")
  })
  default = {}
}

# Terraform state
variable "terraform_state" {
  description = "Terraform state storage configuration."
  type = object({
    container_name = optional(string, "tfstate")
    extra_ip_rules = optional(list(string), [])
  })
  default = {}
}

# Runners
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

# Identity
variable "github_repository" {
  description = "GitHub repository."
  type        = string
}
