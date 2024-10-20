# Environments
resource "github_repository_environment" "this" {
  for_each = local.github_environments

  repository       = data.github_repository.this.name
  environment      = each.key

  dynamic "reviewers" {
    for_each = local.github_environments[each.key].reviewers == {} ? [] : [1]

    content {
      teams = local.github_environments[each.key].reviewers.teams
      users = local.github_environments[each.key].reviewers.users
    }
  }
}

# Environment secrets
locals {
  github_secrets = merge(flatten([ for github_environment in keys(local.github_environments) :  {
      for name, value in local.github_environment_secrets : format("%s_%s", github_environment, name) => {
        "github_environment" = github_environment,
        "name" = name,
        "value" = value 
      }
    }
  ])...)
}

resource "github_actions_environment_secret" "this" {
  for_each = local.github_secrets

  repository       = data.github_repository.this.name
  environment      = github_repository_environment.this[each.value.github_environment].environment
  secret_name      = each.value.name
  plaintext_value  = each.value.value
}
