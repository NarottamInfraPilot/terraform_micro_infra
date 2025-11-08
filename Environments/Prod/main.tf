module "stg" {
  source                   = "../../Modules/Azurerm_storage_account"
  stg_name                 = "prodstorageaccount8210"
  location                 = "East US"
  resource_group_name      = "prod-resource-group"
  account_tier             = "Standard"
  account_replication_type = "GRS" # Changed to Geo-redundant storage for production
}

module "rg" {
  source   = "../../Modules/Azurerm_resource_group"
  rg_name  = "prod-resource-group"
  location = "East US"
  tags = {
    environment = "prod"
  }
}

module "pip" {
  source              = "../../Modules/azurerm_pip"
  pip_name            = "prod-public-ip"
  resource_group_name = module.rg.rg_name
  location            = module.rg.location
  allocation_method   = "Static"
}

module "sql_server_name" {
  source                       = "../../Modules/azurerm_sql_server"
  sql_server_name              = "prodsqlserver8210"
  resource_group_name          = module.rg.rg_name
  location                     = module.rg.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "P@ssw0rd1234" # Note: In production, use Azure Key Vault for passwords
}

module "sql_db" {
  source        = "../../Modules/azurerm_sql_db"
  database_name = "prodsqldb8210"
  collation     = "SQL_Latin1_General_CP1_CI_AS"
  license_type  = "LicenseIncluded"
  max_size_gb   = 100  # Increased for production workload
  sku_name      = "P1" # Changed to Premium tier for production
  enclave_type  = "None"
}

module "k8s_cluster" {
  source              = "../../Modules/azurerm_kubernetes_cluster"
  aks_name            = "prod-aks-cluster"
  location            = module.rg.location
  resource_group_name = module.rg.rg_name
  dns_prefix          = "prodakscluster"
  node_pool_name      = "prodpool"
  node_count          = 3                 # Increased for high availability
  vm_size             = "Standard_D4s_v3" # More powerful VM for production workloads

}

module "acr" {
  source   = "../../Modules/azurerm_container_registry"
  acr_name = "prodcontainerregistry8210"
  location = module.rg.location
  rg_name  = module.rg.rg_name
  tags     = module.rg.tags
}

module "managed_identity" {
  source              = "../../Modules/azurerm_managed_identity"
  location            = module.rg.location
  resource_group_name = module.rg.rg_name
  identity_name       = "prod-managed-identity"
}
