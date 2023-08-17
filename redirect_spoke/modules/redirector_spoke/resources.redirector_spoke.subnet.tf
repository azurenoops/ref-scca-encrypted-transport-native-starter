# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy a Redirector Spoke subnet for Encrypted Transport in a Mission Partner Environment
DESCRIPTION: The following components will be options in this deployment
             * Subnets
             * Network Security Groups

AUTHOR/S: sstjean
*/

###############################################
### Management Spoke Subnet Configuration   ###
###############################################

resource "azurerm_subnet" "redirector_spoke_snets" {
  for_each             = var.redirector_spoke_subnets
  name                 = data.azurenoopsutils_resource_name.snet[each.key].result
  resource_group_name  = module.mod_rg.resource_group_name
  virtual_network_name = azurerm_virtual_network.redirector-vnet.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = lookup(each.value, "service_endpoints", [])
  # Applicable to the subnets which used for Private link endpoints or services 
  private_endpoint_network_policies_enabled     = lookup(each.value, "private_endpoint_network_policies_enabled", null)
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", null)

  dynamic "delegation" {
    for_each = each.value["delegation"] == null ? [] : [1]
    content {
      name = each.value.delegation.name == null ? null : each.value.delegation.name
      service_delegation {
        name    = each.value.delegation.service_delegation.name == null ? null : each.value.delegation.service_delegation.name
        actions = each.value.delegation.service_delegation.actions == null ? null : each.value.delegation.service_delegation.actions
      }
    }
  }
}
