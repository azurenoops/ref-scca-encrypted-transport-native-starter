# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#-------------------------------
# Route Server configuration
#-------------------------------

/*
resource "azurerm_virtual_network_gateway" "vnet_gateway" {
  name                = "vnet-gateway"
  location            = var.location
  resource_group_name = var.encrypted_transport_rg_name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = false
  enable_bgp          = true
  sku                 = "VpnGw1"
  gateway_type        = "Vpn"
  vpn_client_configuration {
    address_space = [""]
   }
    */
