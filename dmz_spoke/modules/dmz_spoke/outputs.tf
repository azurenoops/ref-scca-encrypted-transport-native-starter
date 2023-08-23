###############
# Outputs    ##
###############

output "resource_group_name" {
  description = "The name of the resource group in which DMZ resources are created"
  value       = module.mod_dmz_spoke.resource_group_name
}

output "virtual_network_subnet_ids"{
  description = "The ids of the subnets created in the DMZ spoke vnet"
  value       = module.mod_dmz_spoke.subnet_ids
}

output "virtual_network_id" {
  description = "The id of the virtual network"
  value       = module.mod_dmz_spoke.virtual_network_id
}

output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = module.mod_dmz_spoke.virtual_network_name
}

output "default_subnet_id" {
  description = "The name of the default subnet"
  value       = module.mod_dmz_spoke.subnet_ids[1]
}

output "bgp_subnet_id" {
  description = "The name of the default subnet"
  value       = module.mod_dmz_spoke.subnet_ids[0]
}