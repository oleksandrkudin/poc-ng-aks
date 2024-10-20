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

variable "environment_short_name" {
  description = "Deployment instance short name. Length limit is three chars. Can be used environment short name value."
  type        = string

  validation {
    condition     = length(var.environment_short_name) <= 3
    error_message = "The variable value length must be less or equal to three."
  }
}
