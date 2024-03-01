resource "azurerm_resource_group" "tap" {
  name     = "TAP"
  location = "West Europe"
}

resource "azurerm_container_registry" "acr" {
  name                = "tapregistry20240205"
  resource_group_name = azurerm_resource_group.tap.name
  location            = azurerm_resource_group.tap.location
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