data "azurerm_subscription" "current" {}

data "azurerm_virtual_network" "hub-vnet" {
  name                = var.hub_virtual_network_name
  resource_group_name = var.hub_resource_group_name
}

data "azurerm_storage_account" "hub-st" {
  name                = var.hub_storage_account_name
  resource_group_name = var.hub_resource_group_name
}

data "azurerm_firewall" "hub-fw" {
  name                = var.hub_firewall_name
  resource_group_name = var.hub_resource_group_name
}

data "azurerm_log_analytics_workspace" "hub-logws" {
  name                = var.hub_log_analytics_workspace_name
  resource_group_name = var.hub_log_analytics_workspace_resource_group_name
}
