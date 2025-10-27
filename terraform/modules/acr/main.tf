resource "azurerm_container_registry" "acr" {
  name = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  sku = "Premium" # private endpoints require Premium
  admin_enabled = false
  georeplications = []
}

resource "azurerm_private_endpoint" "acr_pe" {
  name = "${var.prefix}-acr-pe"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  subnet_id = var.subnet_id
  
  private_service_connection {
    name = "acr-psc"
    is_manual_connection = false
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names = ["registry"]
  }
}
