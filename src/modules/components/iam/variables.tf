########################################################
# Global settinngs
########################################################

# variable "product_name" {
#   description = "Product name."
#   type        = string
# }

# variable "environment_name" {
#   description = "Deployment environment name."
#   type        = string
# }

# variable "product_short_name" {
#   description = "Product short name. Length limit is three chars."
#   type        = string

#   validation {
#     condition     = length(var.product_short_name) <= 3
#     error_message = "The variable value length must be less or equal to three."
#   }
# }

# variable "location_short_name" {
#   description = "Azure location short name. Length limit is three chars."
#   type        = string

#   validation {
#     condition     = length(var.location_short_name) <= 3
#     error_message = "The variable value length must be less or equal to three."
#   }
# }

variable "environment" {
  description = "Environment short name. Length limit is three chars."
  type        = string
  default     = null
}

#   validation {
#     condition     = var.environment == null ? true : length(var.environment) <= 3
#     error_message = "The variable value length must be less or equal to three."
#   }
# }

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

}

variable "github_repository" {
  description = "GitHub repository."
  type        = string
}

# variable "resource_group_role_mappings" {
#   type = map(map(object({
#     role_definition_names = list(string)
#   })))
# }

# variable "role_mappings" {
#   type = map(map(object({
#     scope = string
#     role_definition_names = list(string)
#   })))
# }

variable "add_current_identity_role_mapping" {
  type = bool
  default = false
}

variable "all_role_mappings" {
  type = map(map(map(object({
    scope                 = string
    role_definition_names = list(string)
  }))))
}