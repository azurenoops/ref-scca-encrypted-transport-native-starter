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

  hub_resource_group_name  = var.hub_resource_group_name
  hub_virtual_network_name = var.hub_virtual_network_name
  hub_storage_account_name = var.hub_storage_account_name
  hub_firewall_name        = var.hub_firewall_name

  hub_log_analytics_workspace_resource_group_name = var.hub_log_analytics_workspace_resource_group_name
  hub_log_analytics_workspace_name                = var.hub_log_analytics_workspace_name

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

############################################
##  OpenVPN Server VM Configuration  ##
############################################

module "openvpn" {
  source     = "./modules/dmz_openvpn_vm"
  depends_on = [module.dmz_spoke]

  required      = var.required
  location      = var.location
  workload_name = var.workload_name

  dmz_resource_group_name                         = module.dmz_spoke.resource_group_name
  dmz_virtual_network_name                        = module.dmz_spoke.virtual_network_name
  dmz_log_analytics_workspace_resource_group_name = var.hub_log_analytics_workspace_resource_group_name
  dmz_log_analytics_workspace_name                = var.hub_log_analytics_workspace_name

  #---------------------------------
  #  DMZ OpenVPN Key Vault
  #---------------------------------

  kv_ip_allow_list = var.kv_ip_allow_list
  //kv_admin_group_name = var.kv_admin_group_name
  kv_admin_group_object_id = var.kv_admin_group_object_id
  kv_subnet_id             = module.dmz_spoke.openvpn_trusted_subnet_id


  #---------------------------------
  #  DMZ OpenVPN Server VM
  #---------------------------------

  openvpn_server_vm_resource_group_name = module.dmz_spoke.resource_group_name
  openvpn_untrusted_subnet_name         = module.dmz_spoke.openvpn_untrusted_subnet_name
  openvpn_trusted_subnet_name           = module.dmz_spoke.openvpn_trusted_subnet_name

  openvpn_server_vm_name = var.openvpn_server_vm_name
  openvpn_server_vm_size = var.openvpn_server_vm_size

  openvpn_server_vm_admin_username       = var.openvpn_server_vm_admin_username
  openvpn_server_vm_ssh_public_key_path  = var.openvpn_server_vm_ssh_public_key_path
  openvpn_server_vm_ssh_private_key_path = var.openvpn_server_vm_ssh_private_key_path

  openvpn_server_image_publisher = var.openvpn_server_image_publisher
  openvpn_server_image_offer     = var.openvpn_server_image_offer
  openvpn_server_image_sku       = var.openvpn_server_image_sku

  openvpn_client_address_prefix = var.openvpn_client_address_prefix

  openvpn_ca_root_cert_path                = var.openvpn_ca_root_cert_path
  openvpn_dh_cert_path                     = var.openvpn_dh_cert_path
  openvpn_server_public_key_path           = var.openvpn_server_public_key_path
  openvpn_server_private_key_path          = var.openvpn_server_private_key_path
  openvpn_server_private_key_password_path = var.openvpn_server_private_key_password_path
  openvpn_client_dns_server_address        = var.openvpn_client_dns_server_address
}
