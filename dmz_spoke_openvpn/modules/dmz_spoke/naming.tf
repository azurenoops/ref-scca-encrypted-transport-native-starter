# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Generate the names for the route tables for the DMZ subnets
*/

data "azurenoopsutils_resource_name" "untrusted_subnet_route_table" {
  name          = "${var.wl_name}-untrusted-subnet"
  resource_type = "azurerm_route_table"
  prefixes      = [var.required.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : module.mod_azure_region_lookup.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.required.deploy_environment, local.name_suffix, local.specific_name, var.use_naming ? "" : "rt"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "trusted_subnet_route_table" {
  name          = "${var.wl_name}-trusted-subnet"
  resource_type = "azurerm_route_table"
  prefixes      = [var.required.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : module.mod_azure_region_lookup.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.required.deploy_environment, local.name_suffix, local.specific_name, var.use_naming ? "" : "rt"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}