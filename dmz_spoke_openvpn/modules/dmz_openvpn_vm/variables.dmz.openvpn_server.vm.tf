variable "openvpn_server_vm_resource_group_name" {
  description = "The name of the resource group to deploy the OpenVPN Server into."
  type        = string
  default     = null
}

variable "openvpn_server_vm_subnet_name" {
  description = "The name of the subnet to deploy the OpenVPN Server VM into."
  type        = string
  default     = null  
}

variable "openvpn_untrusted_subnet_id" {
  description = "The resource id of the untrusted subnet for the OpenVPN Server's first NIC."
  type        = string
  default     = null  
}

variable "openvpn_trusted_subnet_id" {
  description = "The resource id of the trusted subnet for the OpenVPN Server's second NIC."
  type        = string
  default     = null  
}

variable "openvpn_server_vm_keyvault_id" {
  description = "The ID of the KeyVault to store the OpenVPN Server password."
  type        = string
  default     = null
}

variable "openvpn_server_virtual_machine_admins" {
  description = "Optional list of Azure Active Directory object IDs to assign the Virtual Machine Administrator Login role for the OpenVPN Server."
  type        = list(string)
  default     = []
}

variable "openvpn_server_virtual_machine_users" {
  description = "List of Azure Active Directory object IDs to assign the Virtual Machine User Login role for the OpenVPN Server."
  type        = list(string)
  default     = []
}

variable "openvpn_server_vm_size" {
  description = "The size of the virtual machine to deploy for the OpenVPN Server."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "openvpn_server_vm_admin_username" {
  description = "The admin username to use for the OpenVPN Server."
  type        = string
  default     = "azureuser"
}

variable "openvpn_server_vm_ssh_public_key_path" {
  description = "The SSH public key to use for the OpenVPN Server."
  type        = string
  default     = ""
  sensitive = true
}

variable "openvpn_server_vm_ssh_private_key_path" {
  description = "The SSH private key to use for the OpenVPN Server."
  type        = string
  default     = ""
  sensitive = true
}

variable "openvpn_server_vm_name" {
  description = "The name to use for the OpenVPN Server."
  type        = string
  default     = "openvpnsvrvm"
}

variable "openvpn_server_image_publisher" {
  description = "The publisher of the image to use for the OpenVPN Server."
  type        = string
  default     = "canonical"
}

variable "openvpn_server_image_offer" {
  description = "The offer of the image to use for the OpenVPN Server."
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "openvpn_server_image_sku" {
  description = "The SKU of the image to use for the OpenVPN Server."
  type        = string
  default     = "22_04-lts-gen2"
}



