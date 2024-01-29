// Tanzu Mission Control terraform provider initialization
terraform {
  required_providers {
    tanzu-mission-control = {
      source  = "vmware/tanzu-mission-control"
      version = "1.4.2"
    }
  }
}

// Basic details needed to configure Tanzu Mission Control provider
provider "tanzu-mission-control" {
  endpoint            = var.tmc-endpoint
  vmw_cloud_api_token = var.tmc-vmw_cloud_api_token
}
