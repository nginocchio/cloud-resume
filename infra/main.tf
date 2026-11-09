resource "random_id" "st" {
  byte_length = 4
}

resource "azurerm_resource_group" "portfolio" {
  name     = "rg-portfolio-prod-01"
  location = "westus2"
}

resource "azurerm_static_web_app" "portfolio" {
  name                = "stapp-portfolio-prod-01"
  resource_group_name = azurerm_resource_group.portfolio.name
  location            = azurerm_resource_group.portfolio.location
  sku_tier            = "Free"
}

resource "azurerm_storage_account" "portfolio" {
  name                     = "stportfolioprod${random_id.st.hex}"
  resource_group_name      = azurerm_resource_group.portfolio.name
  location                 = azurerm_resource_group.portfolio.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_cosmosdb_account" "portfolio" {
  name                = "cosmosacc-portfolio-prod-01"
  location            = azurerm_resource_group.portfolio.location
  resource_group_name = azurerm_resource_group.portfolio.name

  offer_type = "Standard"

  capabilities {
    name = "EnableServerless"
  }

  capabilities {
    name = "EnableTable"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.portfolio.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_table" "portfolio" {
  name                = "VisitorCount"
  resource_group_name = azurerm_resource_group.portfolio.name
  account_name        = azurerm_cosmosdb_account.portfolio.name
}
