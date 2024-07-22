########################################################
# Global settinngs
########################################################

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
