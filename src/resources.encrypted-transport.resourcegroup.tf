# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#-------------------------------
# Resource Group configuration
#-------------------------------

resource "azurerm_resource_group" "encrypted_transport_rg" {
  name     = var.encrypted_transport_rg_name
  location = var.location
}

