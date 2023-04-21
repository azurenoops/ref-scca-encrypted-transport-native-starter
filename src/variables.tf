variable "location" {
  type        = string
  description = "The location/region where the resources will be created"
}

variable "subscription_id_hub" {
  type        = string
  description = "The subscription ID of the hub"
}

variable "encrypted_transport_rg_name" {
  type        = string
  description = "The resource group name of the encrypted transport"
}

variable "hub_vnet_name" {
  type        = string
  description = "The name of the hub virtual network"
  default     = null
}

variable "hub_vnet_rg_name" {
  type        = string
  description = "The resource group name of the hub virtual network"
  default     = null
}

