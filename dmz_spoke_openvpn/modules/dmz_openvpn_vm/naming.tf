#############################################
##
##    OpenVPN Server VM Names
##
#############################################

data "azurenoopsutils_resource_name" "ovpn_server_vm" {
  name          = "${var.workload_name}-server"
  resource_type = "azurerm_linux_virtual_machine"
  prefixes      = [var.required.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : module.mod_azure_region_lookup.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.required.deploy_environment, local.name_suffix, local.specific_name, var.use_naming ? "" : "vm"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "ovpn-server-vm-nic-untrusted" {
  name          = "${var.workload_name}-untrusted"
  resource_type = "azurerm_network_interface"
  prefixes      = [var.required.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : module.mod_azure_region_lookup.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.required.deploy_environment, local.name_suffix, local.specific_name, var.use_naming ? "" : "vm"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "ovpn-server-vm-nic-trusted" {
  name          = "${var.workload_name}-trusted"
  resource_type = "azurerm_network_interface"
  prefixes      = [var.required.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : module.mod_azure_region_lookup.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.required.deploy_environment, local.name_suffix, local.specific_name, var.use_naming ? "" : "vm"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}


data "azurenoopsutils_resource_name" "ovpn-server-vm-pip" {
  name          = var.workload_name
  resource_type = "azurerm_public_ip"
  prefixes      = [var.required.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : module.mod_azure_region_lookup.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.required.deploy_environment, local.name_suffix, local.specific_name, var.use_naming ? "" : "pip"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}
