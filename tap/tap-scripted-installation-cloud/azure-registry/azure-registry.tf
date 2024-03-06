resource "azurerm_resource_group" "tap-registry" {
  name     = "tap-registry"
  location = "West Europe"
}

resource "azurerm_container_registry" "acr" {
  name                = "tapregistry20240205"
  resource_group_name = azurerm_resource_group.tap-registry.name
  location            = azurerm_resource_group.tap-registry.location
  sku                 = "Basic"
  admin_enabled       = true
}

output "login_server" {
  value     = azurerm_container_registry.acr.login_server
  sensitive = true
}

output "admin_username" {
  value     = azurerm_container_registry.acr.admin_username
  sensitive = true
}

output "admin_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}