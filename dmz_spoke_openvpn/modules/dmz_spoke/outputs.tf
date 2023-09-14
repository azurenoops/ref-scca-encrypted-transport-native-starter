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

//TODO:  Change these to use the subnet_ids when the Workload Spoke is updated
output "openvpn_trusted_subnet_id"{
  description = "The resource id of of the subnet on the firewall-facing side of the OpenVPN server"
  value       = module.mod_dmz_spoke.subnet_ids["untrusted"].name
}

output "openvpn_untrusted_subnet_id"{
  description = "The resource id of the subnet on the Internet-facing side of the OpenVPN server"
  value       = module.mod_dmz_spoke.subnet_ids["trusted"].name
}


//TODO:  Change these to use the subnet_names when the Workload Spoke is updated
output "openvpn_trusted_subnet_name"{
  description = "The name of the subnet on the firewall-facing side of the OpenVPN server"
  value       = module.mod_dmz_spoke.subnet_names["trusted"].name
}

output "openvpn_untrusted_subnet_name"{
  description = "The name of the subnet on the Internet-facing side of the OpenVPN server"
  value       = module.mod_dmz_spoke.subnet_names["untrusted"].name
}

output "openvpn_untrusted_subnet_nsg_name"{
  description = "The name of the NSG associated with the untrusted subnet"
  value       = module.mod_dmz_spoke.network_security_group_names["untrusted"].name
}

output "openvpn_trusted_subnet_nsg_name"{
  description = "The name of the NSG associated with the trusted subnet"
  value       = module.mod_dmz_spoke.network_security_group_names["trusted"].name
}

output "openvpn_untrusted_subnet_nsg_id"{
  description = "The id of the NSG associated with the untrusted subnet"
  value       = module.mod_dmz_spoke.network_security_group_ids["untrusted"].id
}

output "openvpn_trusted_subnet_nsg_id"{
  description = "The id of the NSG associated with the untrusted subnet"
  value       = module.mod_dmz_spoke.network_security_group_ids["trusted"].id
}

output "openvpn_untrusted_subnet_route_table_name"{
  description = "The name of the route table associated with the untrusted subnet"
  value       = azurerm_route_table.untrusted_subnet_route_table.name
}

output "openvpn_trusted_subnet_route_table_name"{
  description = "The name of the route table associated with the trusted subnet"
  value       = azurerm_route_table.trusted_subnet_route_table.name
}

output "openvpn_untrusted_subnet_route_table_id"{
  description = "The id of the route table associated with the untrusted subnet"
  value       = azurerm_route_table.untrusted_subnet_route_table.id
}

output "openvpn_trusted_subnet_route_table_id"{
  description = "The id of the route table associated with the trusted subnet"
  value       = azurerm_route_table.trusted_subnet_route_table.id
}