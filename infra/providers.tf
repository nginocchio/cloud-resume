terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.11.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.9.1"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-iac-prod-01"
    storage_account_name = "stnginoiacprod01"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "random" {

}

