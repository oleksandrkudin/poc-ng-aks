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

variable "environment" {
  description = "Environment short name. Length limit is three chars."
  type        = string
  default     = null
}

variable "github_repository" {
  description = "GitHub repository."
  type        = string
}

variable "all_role_mappings" {
  type = map(map(map(object({
    scope                 = string
    role_definition_names = list(string)
  }))))
}