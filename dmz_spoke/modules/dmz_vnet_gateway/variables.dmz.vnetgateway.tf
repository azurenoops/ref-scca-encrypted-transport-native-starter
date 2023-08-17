# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#################################
# Route Server Configuration
#################################

variable "location" {
  description = "Azure region in which instance will be hosted"
  type        = string
}

variable "route_server_subnet_address_prefix" {
  description = "The address prefix for the Route Server Subnet. Must be a /27 or larger"
  type        = string
}

variable dmz_virtual_network_name {
  description = "The name of the DMZ virtual network"
  type        = string
}

variable "dmz_resource_group_name" {
  description = "The name of the DMZ resource group"
  type        = string
}