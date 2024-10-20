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

# Terraform state
variable "terraform_state" {
  description = "Terraform state storage configuration."
  type = object({
    container_name = optional(string, "tfstate")
    extra_ip_rules = optional(list(string), [])
  })
  default = {}
}

variable "create_all" {
  type    = bool
  default = false
}

variable "create_resource_group" {
  type    = bool
  default = false
}

variable "create_storage_account" {
  type    = bool
  default = false
}

variable "create_container" {
  type    = bool
  default = false
}

variable "create_role_assignment" {
  type    = bool
  default = false
}