########################################################
# Global settinngs
########################################################

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
  type = string
}

########################################################
# Component specific settinngs
########################################################

variable "kubernetes_cluster" {
  description = "Kubernetes cluster."
  type = object({
    role_based_access_control_enabled = bool
    oidc_issuer_url                   = string
    resource_group_id                 = string
    node_resource_group_id            = string
  })
}

variable "agic" {
  description = "Azure Application Gateway."
  type = object({
    name                = string
    id                  = string
    resource_group_name = string
    gateway_ip_configuration = object({
      subnet_id = string
    })
  })
}