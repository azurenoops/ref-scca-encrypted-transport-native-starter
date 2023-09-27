locals {
  # Naming locals/constants
  redirector_spoke_vnet_name = data.azurenoopsutils_resource_name.vnet.result

  name_prefix   = lower(var.name_prefix)
  name_suffix   = lower(var.name_suffix)
  specific_name = "redirector"
}
