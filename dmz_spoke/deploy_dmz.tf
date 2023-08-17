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
  source = "./modules/dmz_spoke"

  environment              = var.required.environment
  org_name                 = var.required.org_name
  subscription_id_workload = var.dmz_subscription_id
  deploy_environment       = var.required.deploy_environment
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
  source = "./modules/dmz_route_server"
  route_server_subnet_address_prefix = var.route_server_subnet_address_prefix
  location = var.location
  dmz_resource_group_name = module.dmz_spoke.resource_group_name
  dmz_virtual_network_name = module.dmz_spoke.virtual_network_name
}
