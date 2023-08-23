# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.


#############################################
# Virtual Network Gateway Configuration
#############################################


variable "dmz_virtual_network_name" {
  description = "The name of the DMZ virtual network"
  type        = string
}

variable "dmz_resource_group_name" {
  description = "The name of the DMZ resource group"
  type        = string
}

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

