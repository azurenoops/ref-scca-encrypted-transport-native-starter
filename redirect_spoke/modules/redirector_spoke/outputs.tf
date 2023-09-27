output "redirector_public_ip_address" {
  value = azurerm_public_ip.redirect_firewall_public_ip.ip_address
}
