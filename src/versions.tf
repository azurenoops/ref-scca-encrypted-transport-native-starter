# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

terraform {

  # It is recommended to use remote state instead of local
  # This is only used for testing, and should be commented out for production
  /*  backend "azurerm" {
    resource_group_name  = "afmpe-network-artifacts-rg"
    storage_account_name = "afmpetfmgth8dc4qua"
    container_name       = "core-mgt-tfstate"
    key                  = "test.terraform.tfstate"
  }*/

  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.36"
    }
    azurenoopsutils = {
      source  = "azurenoops/azurenoopsutils"
      version = "~> 1.0.4"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id_hub
  features {}
}
