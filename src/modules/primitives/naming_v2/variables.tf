variable "separator" {
  type    = string
  default = "-"
}

variable "product" {
  description = "Product short name. Length limit is three chars."
  type        = string
  default     = null

  validation {
    condition     = var.product == null || try(length(var.product), 4) <= 3
    error_message = "The variable value length must be less or equal to three."
  }
}

variable "location" {
  type    = string
  default = null
}

variable "environment" {
  description = "Deployment instance short name. Length limit is three chars. Can be used environment short name value."
  type        = string
  default     = null

  validation {
    condition     = var.environment == null || try(length(var.environment), 4) <= 3
    error_message = "The variable value length must be less or equal to three."
  }
}

variable "base_name" {
  type    = string
  default = null
}

variable "layer" {
  type    = string
  default = null
}

variable "component" {
  type    = string
  default = null
}

variable "resource_name" {
  type    = string
  default = null
}

variable "resource_type" {
  type    = string
  default = null
}

variable "count_index" {
  type    = number
  default = null
}

variable "resource_version" {
  type    = number
  default = null
}
