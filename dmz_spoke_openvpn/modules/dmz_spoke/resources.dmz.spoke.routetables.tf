# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Creates the appropriate route tables for the trusted and untrusted subnets 
         in the DMZ and makes the appropriate associations
*/

resource "azurerm_route_table" "untrusted_subnet_route_table" {
  name                          = data.azurenoopsutils_resource_name.untrusted_subnet_route_table.result
  location                      = module.mod_azure_region_lookup.location_cli
  resource_group_name           = module.mod_dmz_spoke.resource_group_name
  disable_bgp_route_propagation = true

  route {
    name           = "to-internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
}


resource "azurerm_route_table" "trusted_subnet_route_table" {
  name                          = data.azurenoopsutils_resource_name.trusted_subnet_route_table.result
  location                      = module.mod_azure_region_lookup.location_cli
  resource_group_name           = module.mod_dmz_spoke.resource_group_name
  disable_bgp_route_propagation = true

  route {
    name                   = "to-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = data.azurerm_firewall.hub-fw.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "untrusted_subnet_route_table_association" {
  subnet_id      = module.mod_dmz_spoke.subnet_ids["untrusted"].name
  route_table_id = azurerm_route_table.untrusted_subnet_route_table.id
}

resource "azurerm_subnet_route_table_association" "trusted_subnet_route_table_association" {
  subnet_id      = module.mod_dmz_spoke.subnet_ids["trusted"].name
  route_table_id = azurerm_route_table.trusted_subnet_route_table.id
}

