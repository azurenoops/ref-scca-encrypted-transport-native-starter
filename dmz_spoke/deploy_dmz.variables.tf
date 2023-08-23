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
  description = "If set to true, this will create a new resource group for the DMZ resources."
  default     = true
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

variable "hub_virtual_network_resource_id" {
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



###########################
## Route Server Config  ##
###########################

variable "route_server_subnet_address_prefix" {
  description = "The address prefix for the Route Server Subnet. Must be a /27 or larger"
  type        = string
}

variable "route_server_bgp_asn" {
  description = "The BGP ASN to use for the Route Server."
  type        = number
  validation {
    condition     = (var.route_server_bgp_asn >= 0 && var.route_server_bgp_asn <= 64495) && var.route_server_bgp_asn != 8074 && var.route_server_bgp_asn != 8075 && var.route_server_bgp_asn != 12076 && var.route_server_bgp_asn != 23456
    error_message = "The BGP ASN must be between 0 and 64495 and not 8074, 8075, 12076 & 23456 which are reserved by IANA or Azure."
  }
}

#####################################
## Virtual Network Gateway Config  ##
#####################################

variable "vnet_gateway_subnet_address_prefixes" {
  description = "The address prefixes to be used for the Azure virtual network gateway subnet."
  type        = list(string)
}

variable "vnet_gateway_vpn_client_address_prefixes" {
  description = "The address prefixes to be used for the Azure virtual network gateway vpn client."
  type        = list(string)
}

variable "vnet_gateway_vpn_root_certificate_path" {
  description = "The path to the root certificate for the Azure virtual network gateway vpn client."
  type        = string
}

variable "vnet_gateway_sku" {
  description = "The SKU of the Azure virtual network gateway."
  type        = string
  default     = "VpnGw2"
}



#############################################
##   BGP Linux VM Scale Set Configuration  ##
#############################################

variable "existing_bgp_linux_vmss_resource_group_name" {
  description = "The name of the existing resource group to use."
  type        = string
  default     = null
}

variable "bgp_linux_vmss_ssh_private_key_path" {
  description = "Local path to the Private SSH key file that will be deployed into the KeyVault."
  type        = string
  default     = null
}

variable "bgp_linux_vmss_ssh_public_key_path" {
  description = "Local path to the Public SSH key file that will be deployed on Scale set."
  type        = string
  default     = null
}

variable "bgp_linux_vmss_admin_username" {
  description = "The admin username for the BGP Linux VMSS."
  type        = string
  default     = "azureuser"
}

variable "bgp_linux_vmss_vmsize" {
  description = "The VM size for the BGP Linux VMSS."
  type        = string
  default     = "Standard_DS1_v2"
}

variable "kv_admin_group_name" {
  description = "The name of the group to be given access to the Key Vault."
  type        = string
} 

variable "kv_ip_allow_list"{
  description = "The IP addresses to allow access to the Key Vault."
  type        = list(string)
  default     = []
}


