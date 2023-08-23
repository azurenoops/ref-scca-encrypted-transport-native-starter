# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy a Route Server for Encrypted Transport in a Mission Partner Environment
DESCRIPTION: The following components will be options in this deployment
             * Route Server
             * Public IP Address
             * Specialized Route Server Subnet

AUTHOR/S: sstjean
*/

######################################
###   Route Server Configuration   ###
######################################

// Creating the subnet here because the default creation in the DMZ also adds an NSG
//  to the subnet and the RouteServer will fail to deploy if there is an NSG.
resource "azurerm_subnet" "routeserversubnet" {
  name                 = "RouteServerSubnet"
  virtual_network_name = var.dmz_virtual_network_name
  resource_group_name  = var.dmz_resource_group_name
  address_prefixes     = [var.route_server_subnet_address_prefix]
}

resource "azurerm_public_ip" "route_server_pip" {
  name                = data.azurenoopsutils_resource_name.routeserver-pip.result
  resource_group_name = var.dmz_resource_group_name
  location            = module.mod_azure_region_lookup.location_cli
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_route_server_bgp_connection" "route_server_conn" {
  name            = "rs-bgpconnection"
  route_server_id = azurerm_route_server.dmz_routeserver.id
  peer_asn        = var.route_server_bgp_asn
  peer_ip         = "169.254.21.5"
}


resource "azurerm_route_server" "dmz_routeserver" {
  name                             = data.azurenoopsutils_resource_name.routeserver.result
  resource_group_name              = var.dmz_resource_group_name
  location                         = module.mod_azure_region_lookup.location_cli
  sku                              = "Standard"
  public_ip_address_id             = azurerm_public_ip.route_server_pip.id
  subnet_id                        = azurerm_subnet.routeserversubnet.id
  branch_to_branch_traffic_enabled = true
  
}
