resource "azurerm_virtual_network" "vnet" {
name = "${var.prefix}-vnet"
resource_group_name = azurerm_resource_group.rg.name
address_space = ["10.0.0.0/16"]
  location = var.location
}

resource "azurerm_subnet" "aks" {
  name = "aks-subnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.0.1.0/24"]
    delegations = [{
      name = "aks-delegation"
      service_delegation {
        name = "Microsoft.ContainerService/managedClusters"
      }
    }]
}

resource "azurerm_subnet" "acr_pe" {
  name = "acr-pe-subnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.2.0/28"]
}

resource "azurerm_subnet" "kv_pe" {
  name = "kv-pe-subnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.3.0/28"]
}
