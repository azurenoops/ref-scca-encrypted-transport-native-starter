# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy a Redirector spoke VNet for Encrypted Transport in a Mission Partner Environment
DESCRIPTION: The following components will be options in this deployment
             * Virtual Network


AUTHOR/S: sstjean
*/

###############################################
###   Redirector Spoke VNet Configuration   ###
###############################################

resource "azurerm_virtual_network" "redirector-vnet" {
  name                = data.azurenoopsutils_resource_name.vnet.result
  location            = module.mod_azure_region_lookup.location_full_name
  resource_group_name = module.mod_rg.resource_group_name
  address_space       = var.virtual_network_address_space
  tags                = merge({ "ResourceName" = format("%s", local.redirector_spoke_vnet_name) }, local.workload_resources_tags, var.add_tags, )

}



