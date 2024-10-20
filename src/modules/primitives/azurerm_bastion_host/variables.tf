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

variable "copy_paste_enabled" {
  description = "Whether Copy/Paste feature is enabled."
  type        = bool
  default     = null
}

variable "file_copy_enabled" {
  description = "Whether Copy/Paste feature is enabled."
  type        = bool
  default     = null
}

variable "sku" {
  description = "The SKU of the Bastion Host. Accepted values are Developer, Basic and Standard."
  type        = string
  default     = null
}

variable "ip_connect_enabled" {
  description = "Whether IP Connect feature is enabled."
  type        = bool
  default     = null
}

variable "kerberos_enabled" {
  description = "Whether Kerberos authentication is enabled."
  type        = bool
  default     = null
}

variable "scale_units" {
  description = "The number of scale units with which to provision the Bastion Host. Possible values are between 2 and 50."
  type        = number
  default     = null
}

variable "shareable_link_enabled" {
  description = "Whether Shareable Link feature is enabled."
  type        = bool
  default     = null
}

variable "tunneling_enabled" {
  description = "Whether Tunneling feature is enabled."
  type        = bool
  default     = null
}

variable "virtual_network_id" {
  description = "The id of the Azure DevTest Labs Virtual Network."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet id."
  type        = string
}

variable "public_ip_address_id" {
  description = "Public ip address id."
  type        = string
}