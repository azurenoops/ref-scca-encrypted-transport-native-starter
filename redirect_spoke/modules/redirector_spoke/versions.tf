terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.65.0"
    }
    azurenoopsutils = {
      source  = "azurenoops/azurenoopsutils"
      version = "1.0.4"
    }
  }
}

provider "azurerm" {
  features {}
}

