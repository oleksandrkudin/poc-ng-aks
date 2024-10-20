resource "helm_release" "this" {
  name             = var.release_name
  chart            = var.chart
  version          = var.chart_version
  repository       = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package"
  create_namespace = var.create_namespace
  namespace        = var.namespace
  skip_crds        = var.skip_crds
  timeout          = var.timeout

  wait          = var.wait
  wait_for_jobs = var.wait_for_jobs

  values = [
    templatefile("${path.module}/configs/values.yml.tftpl", {
      subscriptionId   = var.subscription_id
      resourceGroup    = var.agic.resource_group_name
      name             = var.agic.name
      identityClientID = module.workload_identity.client_id
      rbacEnabled      = var.kubernetes_cluster.role_based_access_control_enabled
    })
  ]
}

module "workload_identity_naming" {
  source = "../naming_v2"

  base_name     = var.name
  resource_name = "agic"
}

module "workload_identity" {
  source = "../azurerm_user_assigned_identity"

  name                = module.workload_identity_naming.name
  location            = var.location
  resource_group_name = var.resource_group_name

  federated_identity_credentials = {
    kubernetes = {
      issuer  = var.kubernetes_cluster.oidc_issuer_url
      subject = "system:serviceaccount:${var.namespace}:${var.release_name}"
    }
  }

  role_mappings = {
    aks_rg = {
      scope                 = var.kubernetes_cluster.resource_group_id
      role_definition_names = ["Reader"]
    }
    aks_managed_rg = {
      scope                 = var.kubernetes_cluster.node_resource_group_id
      role_definition_names = ["Contributor"]
    }
    agw = {
      scope                 = var.agic.id
      role_definition_names = ["Contributor"]
    }
    agw_subnet = {
      scope                 = var.agic.gateway_ip_configuration.subnet_id
      role_definition_names = ["Network Contributor"]
    }
  }

  tags = var.tags
}