# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy a Virtual Network Gateway for obfuscated VPN access to a Mission Partner Environment
DESCRIPTION: The following components will be options in this deployment
              * VNet
              * Subnet
              * NSG
              * VNet Gateway
              * Route Server
AUTHOR/S: sstjean
*/


# Configure the minimum required providers supported by this module
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.36"

    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15"
    }
    azurenoopsutils = {
      source  = "azurenoops/azurenoopsutils"
      version = "~> 1.0"
    }
  }

  required_version = ">= 1.3"

  /*  backend "azurerm" {
    resource_group_name  = "afmpe-network-artifacts-rg"
    storage_account_name = "afmpetfmgtprodh8dc4qua"
    container_name       = "core-mgt-prod-tfstate"
    key                  = "code_x"
  } */
}

# Configure the Azure Resource Manager Provider
provider "azurerm" {
  environment     = "public"
  subscription_id = var.dmz_subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}




