resource "tanzu-mission-control_akscluster" "AKS01" {
  credential_name = var.credential_name
  subscription_id = var.subscription_id
  resource_group  = var.resource_group
  name            = "aks01"
  
  meta {
    description = "aks01"
    labels      = { "owner" : "tmc-owner" }
  }
  
  spec {
    cluster_group = var.tmc-cluster_group
    agent_name = "aks01"
    
    config {
      location           = "westeurope"
      kubernetes_version = "1.26.6"
      network_config {
        dns_prefix = "aks01-dns"
      }
    }
    nodepool {
      name = "aks01agent"
      spec {
        count   = 4
        mode    = "SYSTEM"
        vm_size = "Standard_B4ms"
        os_disk_size_gb = 125
        upgrade_config {
          max_surge = "1"
          }
      }
    }

    #nodepool {
    #  name = "aks01user"
    #  spec {
    #    count   = 2
    #    mode    = "USER"
    #    vm_size = "Standard_D8as_v4"
    #    scale_set_priority = "SPOT"
    #    spot_max_price = "0.048"
    #    os_disk_size_gb = 125
    # }
    #}
  }
}
