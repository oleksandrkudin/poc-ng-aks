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

variable "administrator_login" {
  description = "The Administrator login."
  type        = string
  default     = null
}

variable "backup_retention_days" {
  description = "The backup retention days for the MySQL Flexible Server. Possible values are between 1 and 35 days."
  type        = number
  default     = null
}

variable "create_mode" {
  description = "The creation mode which can be used to restore or replicate existing servers. Possible values are Default, PointInTimeRestore, GeoRestore, and Replica."
  type        = string
  default     = null
}

variable "delegated_subnet_id" {
  description = "The ID of the virtual network subnet to create the MySQL Flexible Server."
  type        = string
  default     = null
}

variable "geo_redundant_backup_enabled" {
  description = "Whether geo redundant backup is enabled."
  type        = bool
  default     = null
}

variable "high_availability" {
  description = "High availability configuration."
  type = object({
    mode                      = string
    standby_availability_zone = optional(string)
  })
  default = null
}

variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone to create the MySQL Flexible Server."
  type        = string
  default     = null
}

variable "sku_name" {
  description = "The SKU Name for the MySQL Flexible Server."
  type        = string
  default     = null
}

variable "storage" {
  description = "Storage configuration."
  type = object({
    auto_grow_enabled  = optional(bool)
    io_scaling_enabled = optional(bool)
    iops               = optional(number)
    size_gb            = optional(number)
  })
  default = null
}

variable "mysql_version" {
  description = "The version of the MySQL Flexible Server to use. Possible values are 5.7, and 8.0.21."
  type        = string
  default     = null
}

variable "zone" {
  description = "Specifies the Availability Zone in which this MySQL Flexible Server should be located. Possible values are 1, 2 and 3."
  type        = string
  default     = null
}

variable "mysql_server_parameters" {
  description = "Map of MySQL Flexible Server Configuration parameter name and value."
  type        = map(string)
  default     = {}
}

variable "active_directory_administrators" {
  description = "Map of Azure Active Directory administrator objects."
  type = map(object({
    login     = string
    object_id = string
  }))
  default = {}
}
