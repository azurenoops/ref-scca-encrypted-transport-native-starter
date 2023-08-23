locals {
  # Naming locals/constants
  vnet_gateway_name = data.azurenoopsutils_resource_name.vnetgateway.result

  name_prefix   = lower(var.name_prefix)
  name_suffix   = lower(var.name_suffix)
  specific_name = "vnetgateway"
}
