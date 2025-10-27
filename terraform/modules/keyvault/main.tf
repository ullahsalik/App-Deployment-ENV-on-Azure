resource "azurerm_key_vault" "kv" {
  name = "${var.prefix}-kv"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name = "standard"
  soft_delete_retention_days = 7
  
  network_acls {
    default_action = "Deny"
    bypass = "AzureServices"
    virtual_network_subnet_ids = [var.subnet_id]
  }
}


resource "azurerm_private_endpoint" "kv_pe" {
  name = "${var.prefix}-kv-pe"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  subnet_id = var.kv_pe_subnet_id
  
  private_service_connection {
    name = "kv-psc"
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names = ["vault"]
    is_manual_connection = false
  }
}
