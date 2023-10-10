# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#################################
# Global Configuration
#################################


variable "required" {
  description = "A map of required variables for the deployment"
  default     = null
}

variable "location" {
  description = "Azure region in which instance will be hosted"
  type        = string
}

variable "disable_telemetry" {
  type        = bool
  description = "If set to true, will disable telemetry for the module. See https://aka.ms/alz-terraform-module-telemetry."
  default     = false
}

variable "dmz_subscription_id" {
  description = "Subscription ID where the DMZ will be deployed"
  type        = string
}

variable "create_resource_group" {
  type        = bool
  description = "If set to true, this will create a new resource group for the resources deployed by this module."
  default     = true
}

variable "existing_resource_group_name" {
  type        = string
  description = "If specified and `create_resource_group = true`, this value will be used as the name for the DMZ resource group. If not specified, a name will be generated using the default naming convention."
  default     = ""
}

#################################
# Resource Lock Configuration
#################################

variable "enable_resource_locks" {
  type        = bool
  description = "If set to true, will enable resource locks for all resources deployed by this module where supported."
  default     = false
}

variable "lock_level" {
  description = "The level of lock to apply to the resources. Valid values are CanNotDelete, ReadOnly, or NotSpecified."
  type        = string
  default     = "CanNotDelete"
}

#################
# Workload    ###
#################

variable "wl_name" {
  description = "A name for the workload. It defaults to dmz."
  type        = string
  default     = "dmz"
}

variable "wl_vnet_address_space" {
  description = "The address space (CIDR) of the DMZ virtual network."
  type        = list(string)
  default     = ["10.8.6.0/26"]
}

variable "wl_subnets" {
  description = "A list of subnets to add to the DMZ vnet"
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

variable "is_wl_spoke_deployed_to_same_hub_subscription" {
  description = "Indicates whether the DMZ spoke is deployed to the same hub subscription."
  type        = bool
  default     = true
}

variable "wl_private_dns_zones" {
  description = "The private DNS zones of the DMZ virtual network."
  type        = list(string)
  default     = []
}

variable "use_source_remote_spoke_gateway" {
  description = "Indicates whether to use the source remote spoke gateway."
  type        = bool
  default     = false
}

variable "hub_subscription_id" {
  type        = string
  description = "Identifies the hub subscription for vnet peering."

  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.hub_subscription_id)) || var.hub_subscription_id == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
}
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

/* variable "hub_firewall_private_ip_address" {
  description = "The private IP address of the firewall."
  type        = string
  default     = null
} */

variable "enable_traffic_analytics" {
  description = "Enable Traffic Analytics for NSG Flow Logs"
  type        = bool
  default     = false
}

