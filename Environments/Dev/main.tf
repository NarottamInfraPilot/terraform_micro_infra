module "stg" {
  source                   = "../../Modules/Azurerm_storage_account"
  stg_name                 = "devstorageaccount8210"
  location                 = "East US"
  resource_group_name      = "dev-resource-group"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
