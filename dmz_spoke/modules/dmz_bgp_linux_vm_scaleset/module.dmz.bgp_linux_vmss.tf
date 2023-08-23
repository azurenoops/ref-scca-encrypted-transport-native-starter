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

###################################################
###   BGP Linux VM Scale Set Configuration      ###
###################################################

module "bgp_linux_vmss" {
  source  = "azurenoops/overlays-linux-scaleset/azurerm"
  version = "~> 1.0"

  location           = module.mod_azure_region_lookup.location_cli
  environment        = var.required.environment
  deploy_environment = var.required.deploy_environment
  org_name           = var.required.org_name
  workload_name      = var.workload_name

  create_linux_vmss_resource_group = false
  existing_resource_group_name     = var.dmz_resource_group_name
  subnet_id                        = var.bgp_linux_vmss_subnet_id
  vms_size                         = var.bgp_linux_vmss_vmsize
  source_image_reference           = var.bgp_linux_vmss_source_image_reference
  azure_monitor_agent_enabled      = false

  use_location_short_name = var.use_location_short_name

  admin_username  = var.bgp_linux_vmss_admin_username
  ssh_private_key = file(var.bgp_linux_vmss_ssh_private_key_path)
  ssh_public_key  = file(var.bgp_linux_vmss_ssh_public_key_path)

}

###################################
#
#    Load SSH Key into KeyVault
#      and set permissions so 
#      Admins can access it
#
###################################

resource "azurerm_key_vault_secret" "bgp-vmss-ssh-key" {
  name         = "BGP-VMSS-SSH-Key"
  depends_on   = [module.dmz_keyvault]
  value        = file(var.bgp_linux_vmss_ssh_private_key_path)
  key_vault_id = module.dmz_keyvault.key_vault_id
}
