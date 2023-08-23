# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#################################
# Route Server Configuration
#################################

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

variable dmz_virtual_network_name {
  description = "The name of the DMZ virtual network"
  type        = string
}

variable "dmz_resource_group_name" {
  description = "The name of the DMZ resource group"
  type        = string
}