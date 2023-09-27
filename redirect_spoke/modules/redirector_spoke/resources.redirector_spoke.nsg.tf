# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_network_security_group" "redirector_spoke_nsg" {
  for_each            = var.redirector_spoke_subnets

  name                = data.azurenoopsutils_resource_name.nsg[each.key].result
  resource_group_name = module.mod_rg.resource_group_name
  location            = module.mod_azure_region_lookup.location_cli

  tags                = merge({ "ResourceName" = lower("nsg_${each.key}") }, local.workload_resources_tags, var.add_tags, )
  
dynamic "security_rule" {
    for_each = each.value["nsg_subnet_rules"]

    content {
      name        = security_rule.value["name"]
      description = security_rule.value["description"]
      priority    = security_rule.value["priority"]
      direction   = security_rule.value["direction"]
      access      = security_rule.value["access"]
      protocol    = security_rule.value["protocol"]

      source_port_range  = security_rule.value["source_port_range"]
      source_port_ranges = security_rule.value["source_port_ranges"]

      destination_port_range  = security_rule.value["destination_port_range"]
      destination_port_ranges = security_rule.value["destination_port_ranges"]

      source_address_prefix                 = security_rule.value["source_address_prefix"]
      source_address_prefixes               = security_rule.value["source_address_prefixes"]
      source_application_security_group_ids = security_rule.value["source_application_security_group_ids"]

      destination_address_prefix                 = security_rule.value["destination_address_prefix"]
      destination_address_prefixes               = security_rule.value["destination_address_prefixes"]
      destination_application_security_group_ids = security_rule.value["destination_application_security_group_ids"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsgassoc" {
  for_each                  = var.redirector_spoke_subnets
  subnet_id                 = azurerm_subnet.redirector_spoke_snets[each.key].id
  network_security_group_id = azurerm_network_security_group.redirector_spoke_nsg[each.key].id
}