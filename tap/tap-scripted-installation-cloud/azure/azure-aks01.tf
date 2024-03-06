resource "azurerm_resource_group" "tap" {
  name     = "TAP"
  location = "West Europe"
}
resource "azurerm_kubernetes_cluster" "tapaks01" {
  name                = "tapaks01"
  resource_group_name = azurerm_resource_group.tap.name
  location            = azurerm_resource_group.tap.location
  dns_prefix          = "tapdns01"
  kubernetes_version  = "1.27.7"

  default_node_pool {
    name       = "default"
    temporary_name_for_rotation = "temp"
    node_count = 3
    #vm_size    = "Standard_B4ms"
    vm_size    = "Standard_D8ds_v5"    
    os_disk_size_gb = 128
    orchestrator_version = "1.27.9"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.tapaks01.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.tapaks01.kube_config_raw

  sensitive = true
}