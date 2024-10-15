terraform {
  backend "azurerm" {
    resource_group_name = "NetworkWatcherRG"
    storage_account_name = "711incidentandres"
    container_name = "711-andres-tfstate"
    key = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}



provider "azurerm" {
  features {

  }
}