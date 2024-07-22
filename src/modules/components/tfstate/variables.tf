########################################################
# Global settinngs
########################################################

variable "name" {
  type = string
}

# variable "short_name" {
#   type = string
# }

# variable "environment_short_name" {
#   type = string
# }

variable "tags" {
  type = map(string)
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

variable "terragrunt_remote_backend_path" {
  type = string
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
