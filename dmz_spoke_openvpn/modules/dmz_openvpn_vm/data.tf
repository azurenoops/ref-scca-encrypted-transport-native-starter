
data "azurerm_virtual_network" "dmz_vnet" {
  name                = var.dmz_virtual_network_name
  resource_group_name = var.dmz_resource_group_name
}

data "azurerm_log_analytics_workspace" "dmz_logws" {
  name                = var.dmz_log_analytics_workspace_name
  resource_group_name = var.dmz_log_analytics_workspace_resource_group_name
}

/* data "azuread_group" "admin_group" {
  display_name = var.kv_admin_group_name
}  */


