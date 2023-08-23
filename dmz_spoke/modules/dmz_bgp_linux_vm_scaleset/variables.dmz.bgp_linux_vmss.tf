variable "dmz_virtual_network_name" {
  description = "The name of the DMZ virtual network"
  type        = string
}

variable "dmz_resource_group_name" {
  description = "The name of the DMZ resource group"
  type        = string
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

variable "bgp_linux_vmss_subnet_id" {
  description = "The subnet ID for the BGP Linux VMSS."
  type        = string
  default     = null
}

variable "bgp_linux_vmss_vmsize" {
  description = "The VM size for the BGP Linux VMSS."
  type        = string
  default     = "Standard_DS1_v2"
}

variable "bgp_linux_vmss_source_image_reference" {
  description = "The source image reference for the BGP Linux VMSS."
  type        = map(string)
  default     = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
