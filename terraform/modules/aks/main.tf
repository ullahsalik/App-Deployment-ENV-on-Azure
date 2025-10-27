# Azure Cluster creation
resource "azurerm_kubernetes_cluster" "aks" {
  name = "${var.prefix}-aks"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  
  default_node_pool {
    name = "agentpool"
    node_count = var.node_count
    vm_size = var.node_vm_size
    vnet_subnet_id = var.subnet_id
  }
  
  identity {
    type = "SystemAssigned"
  }
  private_cluster_enabled = true
  api_server_authorized_ip_ranges = [] # keep empty for fully private API, use jumpbox for admin
  addon_profile {
    oms_agent {
      enabled = false
    }
  }
  
  role_based_access_control {
    enabled = true
  }
  
  network_profile {
    network_plugin = "azure"
  }
  
  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = var.ssh_public_key
    }
  }
}

# Grant access for AKS managed identity AcrPull against ACR
resource "azurerm_role_assignment" "acr_pull" {
  scope = var.acr_id
  role_definition_name = "AcrPull"
  principal_id = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

# Grant access to Key Vault via access policy (or use workload identity + RBAC)
resource "azurerm_key_vault_access_policy" "aks_kv" {
  key_vault_id = var.keyvault_id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  secret_permissions = ["get", "list"]
}
