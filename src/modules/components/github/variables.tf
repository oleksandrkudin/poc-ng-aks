variable "environment" {
  description = "Environment short name. Length limit is three chars."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository."
  type        = string
}

variable "azure_client_id" {
  type = string
}

variable "reviewers" {
  type = object({
    teams = optional(list(string))
    users = optional(list(string))
  })
  default = {}
}