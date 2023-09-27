locals {
  untrusted_nic_ip_address       = cidrhost(data.azurerm_subnet.untrusted.address_prefix, 4)
  untrusted_subnet_gateway_ip    = cidrhost(data.azurerm_subnet.untrusted.address_prefix, 1)
  trusted_nic_ip_address         = cidrhost(data.azurerm_subnet.trusted.address_prefix, 4)
  trusted_subnet_gateway_ip      = cidrhost(data.azurerm_subnet.trusted.address_prefix, 1)
  openvpn_client_cidr_host       = cidrhost(var.openvpn_client_address_prefix, 0)
  openvpn_client_cidr_netmask    = cidrnetmask(var.openvpn_client_address_prefix)
  openvpn_client_cidr_gateway_ip = cidrhost(var.openvpn_client_address_prefix, 1)
}
