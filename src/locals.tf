locals {
  hub_vnet_name    = coalesce(var.hub_vnet_name, data.azurerm_subnet.GatewaySubnet.virtual_network_name)
  hub_vnet_rg_name = coalesce(var.hub_vnet_rg_name, data.azurerm_subnet.GatewaySubnet.resource_group_name)
}
