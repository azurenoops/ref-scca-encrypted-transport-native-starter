terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azurenoopsutils = {
      source = "azurenoops/azurenoopsutils"
    }
  }
}

provider "azurerm" {
  environment     = var.required.environment
  subscription_id = var.dmz_subscription_id
  skip_provider_registration = var.required.environment == "usgovernment" ? true : false
  features {}
}

provider "azurerm" {
  alias           = "hub"
  environment     = var.required.environment
  skip_provider_registration = var.required.environment == "usgovernment" ? true : false
  subscription_id = var.hub_subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}


