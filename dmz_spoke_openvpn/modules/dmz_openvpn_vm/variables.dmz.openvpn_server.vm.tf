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

variable "openvpn_untrusted_subnet_name"{
  description = "The name of the subnet on the Internet-facing side of the OpenVPN server"
  type        = string
  default     = null
}


variable "openvpn_trusted_subnet_name"{
  description = "The name of the subnet on the firewall-facing side of the OpenVPN server"
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
  default     = "Standard_D4s_v3"
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
  default     = "suse"
}

variable "openvpn_server_image_offer" {
  description = "The offer of the image to use for the OpenVPN Server."
  type        = string
  default     = "opensuse-leap-15-5"
}

variable "openvpn_server_image_sku" {
  description = "The SKU of the image to use for the OpenVPN Server."
  type        = string
  default     = "gen2"
}

variable "openvpn_client_address_prefix"{
  description = "The address prefix to use for the OpenVPN clients."
  type        = string
}

variable "openvpn_ca_root_cert_path" {
  description = "The local path to the OpenVPN CA root certificate file."
  type        = string
}

variable "openvpn_dh_cert_path" {
  description = "The local path to the OpenVPN Diffie-Hellman certificate file."
  type        = string
}

variable "openvpn_server_public_key_path" {
  description = "The local path to the OpenVPN server public key file."
  type        = string
}

variable "openvpn_server_private_key_path" {
  description = "The local path to the OpenVPN server private key file."
  type        = string
}

variable "openvpn_server_private_key_password_path" {
  description = "The local path to the OpenVPN server private key password file."
  type        = string
}

variable "openvpn_client_dns_server_address" {
  description = "The DNS server address to use for the OpenVPN clients."
  type        = string
  default     = "168.63.129.16"
}