locals {
  prefix = var.prefix
}


module "network" {
  source = "./modules/network"
  prefix = local.prefix
  location = var.location
}


module "acr" {
  source = "./modules/acr"
  prefix = local.prefix
  location = var.location
  vnet_id = module.network.vnet_id
  subnet_id = module.network.acr_private_subnet_id
}


module "keyvault" {
  source = "./modules/keyvault"
  prefix = local.prefix
  location = var.location
  vnet_id = module.network.vnet_id
  subnet_id = module.network.kv_private_subnet_id
}


module "aks" {
  source = "./modules/aks"
  prefix = local.prefix
  location = var.location
  vnet_id = module.network.vnet_id
  subnet_id = module.network.aks_subnet_id
  acr_id = module.acr.acr_id
  keyvault_id = module.keyvault.kv_id
}
