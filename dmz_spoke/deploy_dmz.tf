# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy an DMZ Spoke into an existing SCCA Compliant Environment
DESCRIPTION: The following components will be options in this deployment
             * DMZ Spoke Network Architecture
AUTHOR/S: sstjean
*/

################################
### DMZ Spoke Configuations  ###
################################

module "dmz_spoke" {
  source                   = "./modules/dmz_spoke"
  required                 = var.required
  subscription_id_workload = var.dmz_subscription_id
  wl_name                  = var.workload_name
  create_resource_group    = var.create_resource_group
  location                 = var.location

  ########################################
  #
  #  Hub Information for peering
  #
  ########################################

  hub_virtual_network_id          = var.hub_virtual_network_resource_id
  hub_firewall_private_ip_address = var.hub_firewall_private_ip_address
  hub_storage_account_id          = var.hub_storage_account_resource_id

  hub_managmement_logging_log_analytics_id = var.log_analytics_workspace_resource_id
  hub_managmement_logging_workspace_id     = var.log_analytics_workspace_id

  # Enable NSG Flow Logs
  # By default, this will enable flow logs traffic analytics for all subnets.
  enable_traffic_analytics = true

  ###########################
  #
  #  DMZ Spoke Information
  #
  ###########################

  wl_vnet_address_space = var.dmz_vnet_address_space
  wl_subnets            = var.dmz_vnet_subnets
}

###################################
### Route Server Configuation  ###
###################################
module "dmz_routeserver" {
  source                             = "./modules/dmz_route_server"
  depends_on                         = [module.dmz_vnetgateway]
  required                           = var.required
  location                           = var.location
  workload_name                      = var.workload_name
  route_server_subnet_address_prefix = var.route_server_subnet_address_prefix
  route_server_bgp_asn               = var.route_server_bgp_asn
  dmz_resource_group_name            = module.dmz_spoke.resource_group_name
  dmz_virtual_network_name           = module.dmz_spoke.virtual_network_name
}

############################################
## Virtual Network Gateway Configuation  ###
############################################

module "dmz_vnetgateway" {
  source                                   = "./modules/dmz_vnet_gateway"
  depends_on                               = [module.dmz_spoke]
  required                                 = var.required
  location                                 = var.location
  workload_name                            = var.workload_name
  vnet_gateway_sku                         = var.vnet_gateway_sku
  vnet_gateway_subnet_address_prefixes     = var.vnet_gateway_subnet_address_prefixes
  vnet_gateway_vpn_client_address_prefixes = var.vnet_gateway_vpn_client_address_prefixes
  vnet_gateway_vpn_root_certificate_path   = var.vnet_gateway_vpn_root_certificate_path
  dmz_resource_group_name                  = module.dmz_spoke.resource_group_name
  dmz_virtual_network_name                 = module.dmz_spoke.virtual_network_name
}


############################################
##  BGP Linux VM Scale Set Configuration  ##
############################################

module "dmz_bgp_linux_vmss" {
  source     = "./modules/dmz_bgp_linux_vm_scaleset"
  depends_on = [module.dmz_spoke]

  required      = var.required
  location      = var.location
  workload_name = var.workload_name

  dmz_resource_group_name             = module.dmz_spoke.resource_group_name
  dmz_virtual_network_name            = module.dmz_spoke.virtual_network_name
  bgp_linux_vmss_subnet_id            = module.dmz_spoke.bgp_subnet_id
  bgp_linux_vmss_admin_username       = var.bgp_linux_vmss_admin_username
  bgp_linux_vmss_ssh_private_key_path = var.bgp_linux_vmss_ssh_private_key_path
  bgp_linux_vmss_ssh_public_key_path  = var.bgp_linux_vmss_ssh_public_key_path
  bgp_linux_vmss_vmsize               = var.bgp_linux_vmss_vmsize

  //kv_admin_group_name = var.kv_admin_group_name
  kv_admin_group_id = data.azuread_group.admin_group.id
  kv_ip_allow_list  = var.kv_ip_allow_list
  kv_subnet_id      = module.dmz_spoke.default_subnet_id
}

data "azuread_group" "admin_group" {
  display_name = var.kv_admin_group_name
}
