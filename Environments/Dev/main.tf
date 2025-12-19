# module "stg" {
#   source                   = "../../Modules/Azurerm_storage_account"
#   stg_name                 = "devstorageaccount8210"
#   location                 = "East US"
#   resource_group_name      = module.rg.rg_name
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

module "rg" {
  source   = "../../Modules/Azurerm_resource_group"
  rg_name  = "dev-resource-group"
  location = "East US"
  tags = {
    environment = "dev"
  }
}

# module "pip" {
#   source              = "../../Modules/azurerm_pip"
#   pip_name            = "dev-public-ip"
#   resource_group_name = module.rg.rg_name
#   location            = module.rg.location
#   allocation_method   = "Static"
# }

# module "sql_server_name" {
#   source = "../../Modules/azurerm_sql_server"

#   sql_server_name              = "devsqlserver8210"
#   resource_group_name          = module.rg.rg_name
#   location                     = module.rg.location
#   administrator_login          = "sqladmin"
#   administrator_login_password = "P@ssw0rd1234"
# }

# module "sql_db" {
#   source        = "../../Modules/azurerm_sql_db"
#   database_name = "devsqldb8210"
#   collation     = "SQL_Latin1_General_CP1_CI_AS"
#   license_type  = "LicenseIncluded"
#   max_size_gb   = 10
#   sku_name      = "S0"
#   enclave_type  = "None"
#   server_id     = module.sql_server.id

# }

module "k8s_cluster" {
  source              = "../../Modules/azurerm_kubernetes_cluster"
  aks_name            = "dev-aks-cluster"
  location            = "canada central"
  resource_group_name = "dev-resource-group"
  dns_prefix          = "devakscluster"
  node_pool_name      = "agentpool"
  node_count          = 2
  vm_size             = "Standard_A2_v2"
  depends_on = [ module.rg ]

}

module "acr" {
  depends_on = [ module.rg ]
  source   = "../../Modules/azurerm_container_registry"
  acr_name = "devcontainerregistry8210"
  location = "East US"
  rg_name  = "dev-resource-group"
  tags = {
    environment = "dev"
  }
}
# module "managed_identity" {
#   source              = "../../Modules/azurerm_managed_identity"
#   location            = "East US"
#   resource_group_name = "dev-resource-group"
#   identity_name       = "dev-managed-identity"
# }

