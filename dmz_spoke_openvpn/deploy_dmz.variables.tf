# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###########################
# Global Configuration   ##
###########################

variable "required" {
  description = "A map of required variables for the deployment"
  default     = null
}

variable "location" {
  description = "Azure region in which instance will be hosted"
  type        = string
}

############################
# DMZ Spoke Configuration ##
############################

variable "dmz_subscription_id" {
  description = "Subscription ID where the DMZ will be deployed"
  type        = string
}

variable "workload_name" {
  description = "Name of the capability we are deploying. Used in the standard naming calculation."
  type        = string
  default     = "et-dmz"
}

variable "create_resource_group" {
  description = "Controls if the resource group should be created. If set to false, the resource group name must be provided. Default is false."
  type        = bool
  default     = true
}

variable "existing_resource_group_name" {
  description = "The name of the existing resource group to use. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = ""
}

## Info to create the DMZ VNet and Subnets ##

variable "dmz_vnet_address_space" {
  description = "The address spaces (CIDR ranges) of the DMZ virtual network."
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "dmz_vnet_subnets" {
  description = "A list of subnets to add to the spoke vnet"
  type = map(object({
    #Basic info for the subnet
    name                                       = string
    address_prefixes                           = list(string)
    service_endpoints                          = list(string)
    private_endpoint_network_policies_enabled  = bool
    private_endpoint_service_endpoints_enabled = bool

    # Delegation block - see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#delegation
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    }))

    #Subnet NSG rules - see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group#security_rule
    nsg_subnet_rules = optional(list(object({
      name                                       = string
      description                                = string
      priority                                   = number
      direction                                  = string
      access                                     = string
      protocol                                   = string
      source_port_range                          = optional(string)
      source_port_ranges                         = optional(list(string))
      destination_port_range                     = optional(string)
      destination_port_ranges                    = optional(list(string))
      source_address_prefix                      = optional(string)
      source_address_prefixes                    = optional(list(string))
      source_application_security_group_ids      = optional(list(string))
      destination_address_prefix                 = optional(string)
      destination_address_prefixes               = optional(list(string))
      destination_application_security_group_ids = optional(list(string))
    })))
  }))
}

##  Info to peer to the Hub VNet, force-tunnel to the firewall, and configure Logging ##
variable "hub_resource_group_name" {
  description = "The name of the hub resource group."
  type        = string
  default     = null
}

variable "hub_virtual_network_name"{ 
  description = "The name of the hub virtual network."
  type        = string
  default     = null
}

variable "hub_storage_account_name"{
  description = "The name of the hub storage account."
  type        = string
  default     = null
}

variable "hub_firewall_name"{
  description = "The name of the hub firewall."
  type        = string
  default     = null
}

variable "hub_log_analytics_workspace_resource_group_name"{
  description = "The name of the hub log analytics workspace resource group."
  type        = string
  default     = null
}

variable "hub_log_analytics_workspace_name"{
  description = "The name of the hub log analytics workspace."
  type        = string
  default     = null
}

/* variable "hub_virtual_network_resource_id" {
  description = "Resource ID of the Hub VNet"
  type        = string
}

variable "hub_firewall_private_ip_address" {
  description = "Private IP Address of the Firewall"
  type        = string
}

variable "hub_storage_account_resource_id" {
  description = "Resource ID of the Hub Storage Account"
  type        = string
}

variable "log_analytics_workspace_resource_id" {
  description = "Specifies the id of the Log Analytics Workspace in the hub."
  default     = ""
}

variable "log_analytics_workspace_id" {
  description = "The Log Analytics workspace ID for the hub management logging."
  type        = string
  default     = null
}
 */

##################################
# DMZ OpenVPN VMs Configuration ##
##################################

//---------------------------------
//
//  OpenVPN VMs Key Vault
//
//---------------------------------

variable "kv_ip_allow_list" {
  description = "The IP addresses to allow access to the Key Vault."
  type        = list(string)
  default     = []
}

variable "kv_admin_group_name" {
  description = "The name of the group to be given access to the Key Vault."
  type        = string
}

//---------------------------------
//
//  DMZ OpenVPN Server VM
//
//---------------------------------

variable "openvpn_server_vm_resource_group_name" {
  description = "The name of the resource group to deploy the OpenVPN Server into."
  type        = string
  default     = null
}

variable "openvpn_server_vm_subnet_name" {
  description = "The name of the subnet to deploy the OpenVPN Server into."
  type        = string
  default     = null
}

/* variable "openvpn_server_vm_subnet_id" {
  description = "The resource id of the subnet to deploy the OpenVPN Server into."
  type        = string
  default     = null
}
 */
variable "openvpn_server_vm_keyvault_id" {
  description = "The ID of the KeyVault to store the OpenVPN Server password."
  type        = string
  default     = null
}

variable "openvpn_virtual_machine_admins" {
  description = "Optional list of Azure Active Directory object IDs to assign the Virtual Machine Administrator Login role for the OpenVPN Server."
  type        = list(string)
  default     = []
}

variable "openvpn_virtual_machine_users" {
  description = "List of Azure Active Directory object IDs to assign the Virtual Machine User Login role for the OpenVPN Server."
  type        = list(string)
  default     = []
}

variable "openvpn_server_vm_size" {
  description = "The size of the virtual machine to deploy for the OpenVPN Server."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "openvpn_server_vm_admin_username" {
  description = "The admin username to use for the OpenVPN Server."
  type        = string
  default     = "azureuser"
}

variable "openvpn_server_vm_ssh_public_key_path" {
  description = "The SSH public key to use for the OpenVPN Server."
  type        = string
  default     = ""
  sensitive   = true
}

variable "openvpn_server_vm_ssh_private_key_path" {
  description = "The SSH private key to use for the OpenVPN Server."
  type        = string
  default     = ""
  sensitive   = true
}

variable "openvpn_server_vm_name" {
  description = "The name to use for the OpenVPN Server."
  type        = string
  default     = "OSOVPNSrvr"
}

variable "openvpn_server_image_publisher" {
  description = "The publisher of the image to use for the OpenVPN Server."
  type        = string
  default     = "suse"
}

variable "openvpn_server_image_offer" {
  description = "The offer of the image to use for the OpenVPN Server."
  type        = string
  default     = "opensuse-leap-15-5"
}

variable "openvpn_server_image_sku" {
  description = "The SKU of the image to use for the OpenVPN Server."
  type        = string
  default     = "gen2"
}

