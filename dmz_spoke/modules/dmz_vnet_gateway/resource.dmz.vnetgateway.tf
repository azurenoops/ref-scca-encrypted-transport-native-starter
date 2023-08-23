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

// Creating the Gateway subnet here rather than in the dmz_spoke module because
//    the underlying workload_spoke module uses the resource naming
//    convention for the name rather than 'GatewaySubnet'
resource "azurerm_subnet" "gatewaysubnet" {
  name                 = "GatewaySubnet"
  depends_on           = [data.azurerm_virtual_network.dmz_vnet]
  virtual_network_name = var.dmz_virtual_network_name
  resource_group_name  = var.dmz_resource_group_name
  address_prefixes     = var.vnet_gateway_subnet_address_prefixes
}

resource "azurerm_public_ip" "vnetgatewaypip1" {
  name                = data.azurenoopsutils_resource_name.vnetgatewaypip1.result
  location            = module.mod_azure_region_lookup.location_cli
  resource_group_name = var.dmz_resource_group_name

  allocation_method = "Dynamic"
}

resource "azurerm_public_ip" "vnetgatewaypip2" {
  name                = data.azurenoopsutils_resource_name.vnetgatewaypip2.result
  location            = module.mod_azure_region_lookup.location_cli
  resource_group_name = var.dmz_resource_group_name

  allocation_method = "Dynamic"
}


resource "azurerm_virtual_network_gateway" "dmz_vnet_gateway" {
  name                = local.vnet_gateway_name
  location            = module.mod_azure_region_lookup.location_cli
  resource_group_name = var.dmz_resource_group_name
  depends_on          = [azurerm_subnet.gatewaysubnet]

  type                       = "Vpn"
  vpn_type                   = "RouteBased"
  generation                 = "Generation2"
  active_active              = true
  enable_bgp                 = true



  sku = var.vnet_gateway_sku
  ip_configuration {
    name                          = "${local.vnet_gateway_name}-config1"
    subnet_id                     = azurerm_subnet.gatewaysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vnetgatewaypip1.id
  }
  ip_configuration {
    name                          = "${local.vnet_gateway_name}-config2"
    subnet_id                     = azurerm_subnet.gatewaysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vnetgatewaypip2.id
  }
  vpn_client_configuration {
    address_space        = var.vnet_gateway_vpn_client_address_prefixes
    vpn_client_protocols = ["IkeV2", "OpenVPN"]
    vpn_auth_types       = ["Certificate"]
    root_certificate {
      name             = "Self-Signed-Root-CA"
      public_cert_data = file(var.vnet_gateway_vpn_root_certificate_path)
    }
  }

  tags = merge({ "ResourceName" = format("%s", local.vnet_gateway_name) }, local.workload_resources_tags, var.add_tags, )
}

