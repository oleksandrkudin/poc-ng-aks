# product_name = "Next Generation Cloud Platform"
# product_short_name = "ngp"
product_name       = "Oleksandr Kudin POC"
product_short_name = "ok"
github_repository  = "oleksandrkudin/poc-ng-aks"

zones = ["3"]

resource_groups = ["base", "platform", "elastic", "confluent", "app"]

networking = {
  address_space = ["10.0.0.0/28"]
  subnets = {
    runners = {
      address_prefixes = ["10.0.0.0/28"]
    }
  }
}

github_runners = {
  subnet_key = "runners"
  agent = {
    scope = "oleksandrkudin/poc-ng-aks"
  }
}