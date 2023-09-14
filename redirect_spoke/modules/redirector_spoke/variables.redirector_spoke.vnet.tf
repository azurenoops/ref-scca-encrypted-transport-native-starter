# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##########################
# VNet Configuration    ##
##########################

variable "virtual_network_address_space" {
  description = "The address space to be used for the Azure virtual network."
  default     = []
}

variable "firewall_subnet_address_prefixes" {
  description = "The address prefixes to be used for the Azure firewall subnet."
  default     = []
}

