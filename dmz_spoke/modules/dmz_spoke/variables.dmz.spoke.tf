# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#################################
# Global Configuration
#################################
variable "environment" {
  description = "Name of the environment. This will be used to name the private endpoint resources deployed by this module. default is 'public'"
  type        = string
}

variable "deploy_environment" {
  description = "Name of the workload's environnement (dev, test, prod, etc). This will be used to name the resources deployed by this module. default is 'dev'"
  type        = string
}

variable "org_name" {
  description = "Name of the organization. This will be used to name the resources deployed by this module. default is 'anoa'"
  type        = string
  default     = "anoa"
}

variable "location" {
  type        = string
  description = "If specified, will set the Azure region in which region bound resources will be deployed. Please see: https://azure.microsoft.com/en-gb/global-infrastructure/geographies/"
  default     = "eastus"
}

variable "disable_telemetry" {
  type        = bool
  description = "If set to true, will disable telemetry for the module. See https://aka.ms/alz-terraform-module-telemetry."
  default     = false
}

variable "subscription_id_workload" {
  type        = string
  description = "If specified, identifies the Workload subscription for resource deployment."

  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.subscription_id_workload)) || var.subscription_id_workload == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
}

variable "create_resource_group" {
  type        = bool
  description = "If set to true, this will create a new resource group for the resources deployed by this module."
  default     = true
}

variable "custom_dmz_resource_group_name" {
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

variable "enable_forced_tunneling_on_wl_route_table" {
  description = "Enables forced tunneling from the DMZ VNet to the Hub VNet using the DMZ route table."
  type        = bool
  default     = false
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

variable "hub_virtual_network_id" {
  description = "The ID of the hub virtual network."
  type        = string
  default     = null
}

variable "hub_firewall_private_ip_address" {
  description = "The private IP address of the firewall."
  type        = string
  default     = null
}

variable "hub_storage_account_id" {
  description = "The ID of the hub storage account."
  type        = string
  default     = null
}

variable "hub_managmement_logging_log_analytics_id" {
  description = "The Log Analytics Resource ID for the hub management logging."
  type        = string
  default     = null
}

variable "hub_managmement_logging_workspace_id" {
  description = "The Log Analytics Workspace ID for the hub management logging."
  type        = string
  default     = null
}

variable "enable_traffic_analytics" {
  description = "Enable Traffic Analytics for NSG Flow Logs"
  type        = bool
  default     = false
}