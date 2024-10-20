# "Next Generation Cloud Platform"
product     = "ok"
location    = "francecentral"
environment = "dev"
# address_space         = "10.0.0.0/25"
# runner_scope          = "oleksandrkudin/poc-ng-aks"
github_repository = "oleksandrkudin/poc-ng-aks"

zones = ["3"]
networking = {
  address_space = ["10.100.0.0/24", "10.100.1.0/24"]
  subnets = {
    runner = {
      address_prefixes = ["10.100.0.0/28"]
    }
    jump = {
      address_prefixes = ["10.100.0.16/28"]
    }
    bastion = {
      name             = "AzureBastionSubnet"
      address_prefixes = ["10.100.0.64/26"]
    }
    kubernetes_cluster = {
      address_prefixes = ["10.100.0.128/25"]
    }
    agic = {
      address_prefixes = ["10.100.0.32/27"]
    }
    private_endpoint = {
      address_prefixes = ["10.100.1.0/27"]
    }
    mysql = {
      address_prefixes = ["10.100.1.32/28"]
    }
  }
}
github_runners = {
  subnet_key = "runner"
  agent = {
    scope = "oleksandrkudin/poc-ng-aks"
  }
}
