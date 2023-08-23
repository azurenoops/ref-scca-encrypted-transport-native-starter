data "azurerm_subscription" "current" {}

data "azurenoopsutils_resource_name" "routeserver-pip" {
  name          = "${var.workload_name}-rtserv"
  resource_type = "azurerm_public_ip"
  prefixes      = [var.required.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : module.mod_azure_region_lookup.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.required.deploy_environment, local.name_suffix, var.use_naming ? "" : "pip"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

# TODO - Update this once updated naming provider is deployed
 data "azurenoopsutils_resource_name" "routeserver" {
  name          = var.workload_name
  resource_type = "general" //"azurerm_route_server"
  prefixes      = [var.required.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : module.mod_azure_region_lookup.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.required.deploy_environment, local.name_suffix, var.use_naming ? "" : "rtserv"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
} 




