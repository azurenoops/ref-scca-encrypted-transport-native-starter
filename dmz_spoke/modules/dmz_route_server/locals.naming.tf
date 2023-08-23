locals {
  # Naming locals/constants
  # TODO - Fix this once new naming provider is deployed
  route_server_name = "routeserver" //data.azurenoopsutils_resource_name.routeserver.result

  name_prefix   = lower(var.name_prefix)
  name_suffix   = lower(var.name_suffix)
  specific_name = "routeserver"
}
