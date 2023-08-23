###############################
# Key Vault Configuration   ##
###############################

variable "kv_enabled_for_deployment" {
  description = "Whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the Key Vault."
  type        = bool
  default     = false
}

variable "kv_enabled_for_disk_encryption" {
  description = "Whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  type        = bool
  default     = false
}

variable "kv_enabled_for_template_deployment" {
  description = "Whether Azure Resource Manager is permitted to retrieve secrets from the Key Vault."
  type        = bool
  default     = false
}

/* variable "kv_admin_group_name" {
  description = "The name of the group to be given access to the Key Vault."
  type        = string
} */
variable "kv_admin_group_id" {
  description = "The resource id of the group to be given access to the Key Vault."
  type        = string
}

variable "enable_kv_private_endpoint" {
  description = "Whether to create a private endpoint for the Key Vault."
  type        = bool
  default     = false  
} 

variable "kv_ip_allow_list"{
  description = "The IP addresses to allow access to the Key Vault."
  type        = list(string)
  default     = []
}

variable "kv_subnet_id" {
    description = "The subnet ID to create the Key Vault in."
    type        = string
}

variable "existing_vnet_name" {
  description = "The name of the existing VNet to create the Key Vault in."
  type        = string
  default     = null  
}