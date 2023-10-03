terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "unauthorized_access_to_kubernetes_api_server_detected" {
  source    = "./modules/unauthorized_access_to_kubernetes_api_server_detected"

  providers = {
    shoreline = shoreline
  }
}