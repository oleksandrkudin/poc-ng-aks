locals {
  github_environments = {
    (var.environment) = {
      reviewers = {
        teams = var.reviewers.teams
        users = coalesce(var.reviewers.users, [data.github_user.this.id]) 
      }
    }
    (format("%s-%s", var.environment, "no-approve")) = {
      reviewers = {}
    }
  }

  github_environment_secrets = {
    AZURE_CLIENT_ID = var.azure_client_id
    AZURE_TENANT_ID = data.azurerm_client_config.this.tenant_id
    AZURE_SUBSCRIPTION_ID = data.azurerm_client_config.this.subscription_id
  }
}