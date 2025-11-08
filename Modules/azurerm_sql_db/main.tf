
resource "azurerm_mssql_database" "mssql_database" {
  name         = var.database_name
  server_id    = azurerm_mssql_server.mssql_server.id
  collation    = var.collation
  license_type = var.license_type
  max_size_gb  = var.max_size_gb
  sku_name     = var.sku_name
  enclave_type = var.enclave_type

  tags = {
    foo = "bar"
  }

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}