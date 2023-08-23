data "azurerm_subscription" "current" {}

data "azurenoopsutils_resource_name" "vnetgateway" {
  name          = var.workload_name
  resource_type = "azurerm_virtual_network_gateway"
  prefixes      = [var.required.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : module.mod_azure_region_lookup.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.required.deploy_environment, local.name_suffix, var.use_naming ? "" : "vgw"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "vnetgatewaypip1" {
  name          = "${var.workload_name}"
  resource_type = "azurerm_public_ip"
  prefixes      = [var.required.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : module.mod_azure_region_lookup.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.required.deploy_environment, local.name_suffix, "1",var.use_naming ? "" : "pip"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "vnetgatewaypip2" {
  name          = "${var.workload_name}"
  resource_type = "azurerm_public_ip"
  prefixes      = [var.required.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : module.mod_azure_region_lookup.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.required.deploy_environment, local.name_suffix, "2",var.use_naming ? "" : "pip"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurerm_virtual_network" "dmz_vnet" {
  name                = var.dmz_virtual_network_name
  resource_group_name = var.dmz_resource_group_name
}