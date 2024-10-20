module "naming" {
  source = "../naming_v2"

  base_name     = var.name
  resource_type = "azurerm_kubernetes_cluster"
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "azurerm_key_vault_secret" "ssh_private_key" {
  name         = format("%s-%s", module.naming.name, "ssh-private-key")
  key_vault_id = var.key_vault_id
  value        = tls_private_key.ssh.private_key_openssh
  tags         = var.tags
}

module "identity" {
  source              = "../azurerm_user_assigned_identity"
  name                = module.naming.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

module "identity_role_mapping" {
  source = "../azurerm_role_mapping"

  principal_id = module.identity.principal_id
  role_mappings = merge(
    var.private_dns_zone_id == null ? {} : {
      private_dns_zone = {
        scope                 = var.private_dns_zone_id
        role_definition_names = ["Private DNS Zone Contributor"]
      }
    }
  )
}

resource "azurerm_kubernetes_cluster" "this" {
  name                       = module.naming.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  dns_prefix                 = var.dns_prefix
  dns_prefix_private_cluster = var.dns_prefix_private_cluster


  default_node_pool {
    name                    = var.default_node_pool.name
    vm_size                 = var.default_node_pool.vm_size
    custom_ca_trust_enabled = var.default_node_pool.custom_ca_trust_enabled

    kubelet_disk_type            = var.default_node_pool.kubelet_disk_type # OS, temporary
    max_pods                     = var.default_node_pool.max_pods
    message_of_the_day           = var.default_node_pool.message_of_the_day
    node_labels                  = var.default_node_pool.node_labels
    only_critical_addons_enabled = var.default_node_pool.only_critical_addons_enabled # CriticalAddonsOnly=true:NoSchedule
    orchestrator_version         = var.default_node_pool.orchestrator_version
    os_disk_size_gb              = var.default_node_pool.os_disk_size_gb
    os_disk_type                 = var.default_node_pool.os_disk_type
    os_sku                       = var.default_node_pool.os_sku # AzureLinux, Ubuntu, Windows2019 and Windows2022. Default is Ubuntu.
    pod_subnet_id                = var.default_node_pool.pod_subnet_id
    snapshot_id                  = var.default_node_pool.snapshot_id
    temporary_name_for_rotation  = var.default_node_pool.temporary_name_for_rotation
    type                         = var.default_node_pool.type
    ultra_ssd_enabled            = var.default_node_pool.ultra_ssd_enabled
    vnet_subnet_id               = var.default_node_pool.vnet_subnet_id
    zones                        = var.zones
    enable_auto_scaling          = var.default_node_pool.enable_auto_scaling
    max_count                    = var.default_node_pool.max_count
    min_count                    = var.default_node_pool.min_count
    node_count                   = var.default_node_pool.node_count
    tags                         = var.tags
  }

  # aci_connector_linux {}  # skip it for now;

  automatic_channel_upgrade = var.automatic_channel_upgrade

  # api_server_access_profile {}  # skip it for now; focus on private cluster

  # TODO: Return to it later. Auto scaler for which pool? default?
  auto_scaler_profile {}

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.azure_active_directory_role_based_access_control == null ? [] : [1]

    content {
      managed                = true
      tenant_id              = var.azure_active_directory_role_based_access_control.tenant_id
      admin_group_object_ids = var.azure_active_directory_role_based_access_control.admin_group_object_ids
      azure_rbac_enabled     = var.azure_active_directory_role_based_access_control.azure_rbac_enabled
    }
  }

  azure_policy_enabled = var.azure_policy_enabled

  # confidential_computing {}  # skip it for now
  # cost_analysis_enabled  # skip it for now

  custom_ca_trust_certificates_base64 = var.custom_ca_trust_certificates_base64

  # disk_encryption_set_id  # skip it for now
  # edge_zone  # skip it for now
  # http_application_routing_enabled  # skip it for now
  # http_proxy_config {}  # skip it for now

  # kubelet identity?
  # cluster's control plane and addon pods uses identity
  identity {
    type         = "UserAssigned"
    identity_ids = [module.identity.id]
  }

  # kubelet_identity {} # skip it for now; focus to use system-defined managed identity.

  # Clean unused container images
  image_cleaner_enabled        = var.image_cleaner_enabled
  image_cleaner_interval_hours = var.image_cleaner_interval_hours

  # ingress_application_gateway {}  # skip it for now
  # key_management_service {}  # skip it for now; etcd encryption

  # Secrets Store CSI Driver - allow pod to access secrets from Azure Key Vaults.
  dynamic "key_vault_secrets_provider" {
    for_each = var.key_vault_secrets_provider == null ? [] : [1]

    content {
      secret_rotation_enabled  = var.key_vault_secrets_provider.secret_rotation_enabled
      secret_rotation_interval = var.key_vault_secrets_provider.secret_rotation_interval
    }
  }

  kubernetes_version = var.kubernetes_version

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = trimspace(tls_private_key.ssh.public_key_openssh)
    }
  }

  local_account_disabled = var.local_account_disabled

  # maintenance_window {}  # skip it for now
  # maintenance_window_auto_upgrade {}  # skip it for now
  # maintenance_window_node_os {}  # skip it for now

  # microsoft_defender {}  # skip it for now

  # Required for Managed Prometheus
  dynamic "monitor_metrics" {
    for_each = var.monitor_metrics == null ? [] : [1]

    content {
      annotations_allowed = var.monitor_metrics.annotations_allowed
      labels_allowed      = var.monitor_metrics.labels_allowed
    }
  }

  dynamic "network_profile" {
    for_each = var.network_profile == null ? [] : [1]

    content {
      network_plugin = var.network_profile.network_plugin
      network_mode   = var.network_profile.network_mode
      network_policy = var.network_profile.network_policy
      # network_data_plane =   # azure or cilium. Can be skipped for now.
      outbound_type = var.network_profile.outbound_type # loadBalancer, userDefinedRouting, managedNATGateway, userAssignedNATGateway. Default is loadBalancer.
    }
  }

  node_os_channel_upgrade = var.node_os_channel_upgrade

  node_resource_group = var.node_resource_group

  oidc_issuer_enabled = var.oidc_issuer_enabled

  dynamic "oms_agent" {
    for_each = var.oms_agent == null ? [] : [1]

    content {
      log_analytics_workspace_id      = var.oms_agent.log_analytics_workspace_id
      msi_auth_for_monitoring_enabled = var.oms_agent.msi_auth_for_monitoring_enabled
    }
  }

  # open_service_mesh_enabled  # Open Service Mesh (OSM). Envoy-based control plane

  private_cluster_enabled             = var.private_cluster_enabled
  private_dns_zone_id                 = var.private_dns_zone_id
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled

  # service_mesh_profile {}
  # workload_autoscaler_profile {}  # KEDA

  workload_identity_enabled = var.workload_identity_enabled

  role_based_access_control_enabled = var.role_based_access_control_enabled # API Server authorization mode = RBAC.
  run_command_enabled               = var.run_command_enabled
  sku_tier                          = var.sku_tier

  # Storage CSI drivers
  dynamic "storage_profile" {
    for_each = var.storage_profile == null ? [] : [1]

    content {
      blob_driver_enabled         = var.storage_profile.blob_driver_enabled
      disk_driver_enabled         = var.storage_profile.disk_driver_enabled
      disk_driver_version         = var.storage_profile.disk_driver_version
      file_driver_enabled         = var.storage_profile.file_driver_enabled
      snapshot_controller_enabled = var.storage_profile.snapshot_controller_enabled
    }
  }

  support_plan = var.support_plan

  # web_app_routing {}  # Kubernetes NGINX Ingress controller - HTTP, HTTPS traffic

  tags = var.tags
}