# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Azure NoOps Naming - This should be used on all resource naming
#------------------------------------------------------------
data "azurenoopsutils_resource_name" "rg" {
  name          = var.workload_name
  resource_type = "azurerm_resource_group"
  prefixes      = [var.required.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : module.mod_azure_region_lookup.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.required.deploy_environment, local.name_suffix, var.use_naming ? "" : "rg"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "vnet" {
  name          = var.workload_name
  resource_type = "azurerm_virtual_network"
  prefixes      = [var.required.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : module.mod_azure_region_lookup.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.required.deploy_environment, local.name_suffix, var.use_naming ? "" : "vnet"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

  data "azurenoopsutils_resource_name" "snet" {
  for_each      = var.redirector_spoke_subnets
  name          = var.workload_name
  resource_type = "azurerm_subnet"
  prefixes      = [var.required.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : module.mod_azure_region_lookup.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.required.deploy_environment, each.key, local.name_suffix, var.use_naming ? "" : "snet"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}


data "azurenoopsutils_resource_name" "nsg" {
  for_each      = var.redirector_spoke_subnets
  name          = var.workload_name
  resource_type = "azurerm_network_security_group"
  prefixes      = [var.required.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : module.mod_azure_region_lookup.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.required.deploy_environment, each.key, local.name_suffix, var.use_naming ? "" : "nsg"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}  
