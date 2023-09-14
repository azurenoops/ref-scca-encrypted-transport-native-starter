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
  features {}
}

provider "azurerm" {
  alias           = "hub"
  environment     = "public"
  subscription_id = var.subscription_id_workload
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}


