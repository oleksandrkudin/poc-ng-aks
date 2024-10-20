variable "name" {
  description = "Name of the resource."
  type        = string
}

variable "location" {
  description = "Azure location."
  type        = string
}

variable "managed_by" {
  description = "The ID of the resource or application that manages this Resource Group."
  type        = string
  default     = null
}

variable "tags" {
  description = "Azure resource tags."
  type        = map(string)
  default     = null
}