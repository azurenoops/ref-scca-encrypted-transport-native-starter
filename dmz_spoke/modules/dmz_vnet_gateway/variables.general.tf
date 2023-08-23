
variable "required" {
  description = "A map of required variables for the deployment"
  default     = null
  /*
  // Example of how to use the required variable
  required = {
    org_name           = "myOrg"
    deploy_environment = "dev"
    environment        = "public"
    metadata_host      = "management.azure.com" 
}*/
}

variable "location" {
  description = "Azure region in which instance will be hosted"
  type        = string
}

variable "workload_name" {
  description = "Name of the capability we are deploying. Used in the standard naming calculation."
  type        = string
}

variable "disable_telemetry" {
  type        = bool
  description = "If set to true, will disable telemetry for the module. See https://aka.ms/alz-terraform-module-telemetry."
  default     = false
}



####################################
# Generic naming Configuration    ##
####################################
variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name"
  type        = string
  default     = ""
}

variable "use_naming" {
  description = "Use the Azure NoOps naming provider to generate default resource name. `storage_account_custom_name` override this if set. Legacy default name is used if this is set to `false`."
  type        = bool
  default     = true
}

variable "use_location_short_name" {
  description = "Use the short name of the location for the resource group name"
  type        = bool
  default     = true
}