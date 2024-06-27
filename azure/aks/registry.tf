resource "azurerm_container_registry" "mln-acr" {
  name                = var.name_container_registry
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false
}