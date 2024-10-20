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

variable "dns_prefix" {
  description = "DNS prefix specified when creating the managed cluster. Possible values must begin and end with a letter or number, contain only letters, numbers, and hyphens and be between 1 and 54 characters in length."
  type        = string
  default     = null
}

variable "dns_prefix_private_cluster" {
  description = "Specifies the DNS prefix to use with private clusters."
  type        = string
  default     = null
}

variable "default_node_pool" {
  description = "Default node pool configuration."
  type = object({
    name                         = string
    vm_size                      = string
    custom_ca_trust_enabled      = optional(bool)
    kubelet_disk_type            = optional(string)
    max_pods                     = optional(number)
    message_of_the_day           = optional(string)
    node_labels                  = optional(map(string))
    only_critical_addons_enabled = optional(bool)
    orchestrator_version         = optional(string)
    os_disk_size_gb              = optional(string)
    os_disk_type                 = optional(string)
    os_sku                       = optional(string)
    pod_subnet_id                = optional(string)
    snapshot_id                  = optional(string)
    temporary_name_for_rotation  = optional(string)
    type                         = optional(string)
    ultra_ssd_enabled            = optional(bool)
    vnet_subnet_id               = optional(string)
    enable_auto_scaling          = optional(bool)
    max_count                    = optional(number)
    min_count                    = optional(number)
    node_count                   = optional(number)
  })
}

variable "zones" {
  description = "Specifies a list of Availability Zones across which the Virtual Machine Scale Set will create instances."
  type        = list(string)
  default     = null
}

variable "automatic_channel_upgrade" {
  description = "The upgrade channel for this Kubernetes Cluster. Possible values are patch, rapid, node-image and stable."
  type        = string
  default     = null
}

variable "azure_active_directory_role_based_access_control" {
  description = "Azure Active Directory RBAC configuration."
  type = object({
    tenant_id              = optional(string)
    admin_group_object_ids = optional(list(string))
    azure_rbac_enabled     = optional(bool)
  })
  default = null
}

variable "azure_policy_enabled" {
  description = "Whether to enable Azure Policy Add-On."
  type        = bool
  default     = null
}

variable "custom_ca_trust_certificates_base64" {
  description = "list of up to 10 base64 encoded CAs that will be added to the trust store on nodes with the custom_ca_trust_enabled feature enabled."
  type        = list(string)
  default     = null
}

variable "image_cleaner_enabled" {
  description = "Whether Image Cleaner is enabled."
  type        = bool
  default     = null
}

variable "image_cleaner_interval_hours" {
  description = "Specifies the interval in hours when images should be cleaned up."
  type        = number
  default     = null
}

variable "key_vault_secrets_provider" {
  description = "Whether Key Vault Secrets provider is enabled."
  type = object({
    secret_rotation_enabled  = optional(bool)
    secret_rotation_interval = optional(string)
  })
  default = null
}

variable "kubernetes_version" {
  description = "Version of Kubernetes specified when creating the AKS managed cluster."
  type        = string
  default     = null
}

variable "admin_username" {
  description = "The Admin Username for the Cluster."
  type        = string
}

variable "local_account_disabled" {
  description = "Whether local account is disabled."
  type        = bool
  default     = null
}

variable "monitor_metrics" {
  description = "Specifies a Prometheus add-on profile for the Kubernetes Cluster."
  type = object({
    annotations_allowed = optional(string)
    labels_allowed      = optional(string)
  })
  default = null
}

variable "network_profile" {
  description = "Network profile configuration."
  type = object({
    network_plugin = string
    network_mode   = optional(string)
    network_policy = optional(string)
    outbound_type  = optional(string)
  })
}

variable "node_os_channel_upgrade" {
  description = "The upgrade channel for this Kubernetes Cluster Nodes' OS Image. Possible values are Unmanaged, SecurityPatch, NodeImage and None."
  type        = string
  default     = null
}

variable "node_resource_group" {
  description = "The name of the Resource Group where the Kubernetes Nodes should exist."
  type        = string
  default     = null
}

variable "oidc_issuer_enabled" {
  description = "Whether to enable OIDC issuer URL."
  type        = bool
  default     = null
}

variable "oms_agent" {
  description = "OMS agent configuration."
  type = object({
    log_analytics_workspace_id      = string
    msi_auth_for_monitoring_enabled = optional(bool)
  })
  default = null
}

variable "private_cluster_enabled" {
  description = "Should this Kubernetes Cluster have its API server only exposed on internal IP addresses."
  type        = bool
  default     = null
}

variable "private_dns_zone_id" {
  description = "Either the ID of Private DNS Zone which should be delegated to this Cluster, System to have AKS manage this or None."
  type        = string
  default     = null
}

variable "private_cluster_public_fqdn_enabled" {
  description = "Whether a Public FQDN for this Private Cluster should be added."
  type        = bool
  default     = null
}

variable "workload_identity_enabled" {
  description = "whether Azure AD Workload Identity is enabled."
  type        = bool
  default     = null
}

variable "role_based_access_control_enabled" {
  description = "Whether Role Based Access Control for the Kubernetes Cluster should be enabled."
  type        = bool
  default     = null
}

variable "run_command_enabled" {
  description = "Whether to enable run command for the cluster or not."
  type        = bool
  default     = null
}

variable "sku_tier" {
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free, Standard and Premium."
  type        = string
  default     = null
}

variable "storage_profile" {
  description = "Storage profile configuration."
  type = object({
    blob_driver_enabled         = optional(bool)
    disk_driver_enabled         = optional(bool)
    disk_driver_version         = optional(string)
    file_driver_enabled         = optional(bool)
    snapshot_controller_enabled = optional(bool)
  })
  default = null
}

variable "support_plan" {
  description = "Specifies the support plan which should be used for this Kubernetes Cluster. Possible values are KubernetesOfficial and AKSLongTermSupport."
  type        = string
  default     = null
}