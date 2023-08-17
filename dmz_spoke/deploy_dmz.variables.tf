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