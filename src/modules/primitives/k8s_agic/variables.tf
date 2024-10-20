# Helm release variables

variable "release_name" {
  description = "Release name."
  type        = string
  default     = "ingress-azure"
}

variable "chart" {
  description = "Helm chart name."
  type        = string
  default     = "ingress-azure"
}

variable "chart_version" {
  description = "Chart version."
  type        = string
  default     = "1.7.4"
}

variable "namespace" {
  description = "Namespace name."
  type        = string
  default     = "ingress-azure"
}

variable "create_namespace" {
  description = "Whether to create namespace."
  type        = bool
  default     = true
}

variable "skip_crds" {
  description = "Whether to skip CRDs installation."
  type        = bool
  default     = null
}

variable "timeout" {
  description = "Time in seconds to wait for any individual kubernetes operation."
  type        = number
  default     = null
}

variable "wait" {
  description = "Whether to wait until all resources are in a ready state before marking the release as successful."
  type        = bool
  default     = null
}

variable "wait_for_jobs" {
  description = "Whether to wait until all Jobs have been completed before marking the release as successful."
  type        = bool
  default     = null
}

# Chart values

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

variable "subscription_id" {
  type = string
}

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
