# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy a DMZ Spoke  for Encrypted Transport in a Mission Partner Environment
DESCRIPTION: The following components will be options in this deployment
             * Resource Group
             * Virtual Network
             * Subnets
             * Network Security Groups


AUTHOR/S: sstjean
*/

######################################
###   DMZ Spoke Configuration      ###
######################################

module "mod_dmz_spoke" {
  providers = { azurerm.hub_network = azurerm.hub }
  source    = "azurenoops/overlays-dmz-spoke/azurerm"
  version   = "~> 3.0"

  # By default, this module will create a resource group. 
  # To use an existing resource group, specify the existing resource group name, 
  # and set the argument to `create_resource_group = false`. Location will be same as existing RG.
  create_spoke_resource_group  = var.create_resource_group
  existing_resource_group_name = var.existing_resource_group_name

  location           = module.mod_azure_region_lookup.location_cli
  deploy_environment = var.required.deploy_environment
  org_name           = var.required.org_name
  environment        = var.required.environment
  workload_name      = var.wl_name

  # Collect Hub network details for peering.
  hub_resource_group_name         = var.hub_resource_group_name
  hub_virtual_network_name        = data.azurerm_virtual_network.hub-vnet.name
  hub_firewall_private_ip_address = data.azurerm_firewall.hub-fw.ip_configuration.0.private_ip_address


  # (Required) Log Analytics information for Azure monitoring and flow logs. 
  # The log_analytics_logs_retention_in_days values range between 30 and 730
  log_analytics_workspace_id           = data.azurerm_log_analytics_workspace.hub-logws.id
  log_analytics_customer_id            = data.azurerm_log_analytics_workspace.hub-logws.workspace_id
  log_analytics_logs_retention_in_days = 30

  # Enable Flow Logs
  # By default, this will enable the traffic analytics flow logs for all subnets.
  enable_traffic_analytics = var.enable_traffic_analytics

  # Provide valid VNet CIDR Address space for the DMZ virtual network.    
  virtual_network_address_space = var.wl_vnet_address_space # (Required)  Spoke Virtual Network Parameters

  # (Required) Definition of Subnets, Service delegation, Service Endpoints, Network security groups to be created
  # This list includes the Default subnet.  If not specified, no Subnets will be added to the VNet
  # Check README.md for more details
  # Route_table and NSG association to be added automatically for all subnets listed here.
  # subnet name will be set as per Azure naming convention by default. expected value here is: <App or project name>
  spoke_subnets = var.wl_subnets


  # Private DNS Zone Settings
  # By default, Azure NoOps will create Private DNS Zones for Logging in Hub VNet.
  # If you want to create additional Private DNS Zones, 
  # then add them into the list of private_dns_zones to be created.
  # else, remove the private_dns_zones argument.
  private_dns_zones = var.wl_private_dns_zones

  # Peering
  # By default, Azure NoOps will create peering between the Hub and the DMZ spoke.
  # Since is using a gateway, set the argument to `use_source_remote_spoke_gateway = true`, to enable gateway traffic.   
  use_source_remote_spoke_gateway = var.use_source_remote_spoke_gateway

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = var.enable_resource_locks

  # Tags
  add_tags = local.workload_resources_tags # Tags to be applied to all resources

}
