# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy a VNet Gateway for Encrypted Transport in a Mission Partner Environment
DESCRIPTION: The following components will be options in this deployment
             * Virtual Network Gateway
             *

AUTHOR/S: sstjean
*/

#################################################
###   Virtual Network Gateway Configuration   ###
#################################################

resource "azurerm_subnet" "routeserversubnet" {
  name                 = "RouteServerSubnet"
  virtual_network_name = var.dmz_virtual_network_name
  resource_group_name  = var.dmz_resource_group_name
  address_prefixes     = [var.route_server_subnet_address_prefix]
}

resource "azurerm_public_ip" "route_server_pip" {
  name                = "route-server-pip"
  resource_group_name = var.dmz_resource_group_name
  location            = module.mod_azure_region_lookup.location_cli
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_route_server" "dmz-routeserver" {
  name                             = "dmz-routeserver"
  resource_group_name              = var.dmz_resource_group_name
  location                         = module.mod_azure_region_lookup.location_cli
  sku                              = "Standard"
  public_ip_address_id             = azurerm_public_ip.route_server_pip.id
  subnet_id                        = azurerm_subnet.routeserversubnet.id
  branch_to_branch_traffic_enabled = true
}
