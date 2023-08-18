resource "azurerm_subnet" "firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = module.mod_rg.resource_group_name
  virtual_network_name = azurerm_virtual_network.redirector-vnet.name
  address_prefixes     = var.firewall_subnet_address_prefixes
}

resource "azurerm_public_ip" "redirect_firewall_public_ip" {
  name                = data.azurenoopsutils_resource_name.fw-pip.result
  location            = module.mod_azure_region_lookup.location_cli
  resource_group_name = module.mod_rg.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "redirect_firewall" {
  name                = data.azurenoopsutils_resource_name.fw.result
  location            = module.mod_azure_region_lookup.location_cli
  resource_group_name = module.mod_rg.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "fw_ip_configuration"
    subnet_id            = azurerm_subnet.firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.redirect_firewall_public_ip.id
  }
}

resource "azurerm_firewall_nat_rule_collection" "redirect_dnat_rule_collection" {
  name                = "redirect_dnat_rule_collection"
  azure_firewall_name = azurerm_firewall.redirect_firewall.name
  resource_group_name = module.mod_rg.resource_group_name
  priority            = 100
  action              = "Dnat"

  rule {
    name                  = "redirectrule"
    source_addresses      = ["0.0.0.0/0"]
    destination_ports     = ["1194"]
    destination_addresses = [azurerm_public_ip.redirect_firewall_public_ip.ip_address]
    protocols             = ["TCP", "UDP"]
    translated_address    = var.dmz_vnet_gateway_public_ip_address
    translated_port       = "1194"
  }
}
