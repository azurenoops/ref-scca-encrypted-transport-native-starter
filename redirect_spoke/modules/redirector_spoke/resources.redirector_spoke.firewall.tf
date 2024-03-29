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
  depends_on          = [azurerm_firewall_policy.redirect_policy]
  name                = data.azurenoopsutils_resource_name.fw.result
  location            = module.mod_azure_region_lookup.location_cli
  resource_group_name = module.mod_rg.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.redirect_policy.id

  ip_configuration {
    name                 = "fw_ip_configuration"
    subnet_id            = azurerm_subnet.firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.redirect_firewall_public_ip.id
  }

}

#######################################################
## Redirect Policy Configuration
#######################################################
/* resource "azurerm_firewall_nat_rule_collection" "redirect-collection" {
  name                = "redirect-collection"
  azure_firewall_name = azurerm_firewall.redirect_firewall.name
  resource_group_name = module.mod_rg.resource_group_name
  priority            = 100
  action              = "Dnat"

  rule {
    name                  = "redirect-rule"
    source_addresses      = ["*"]
    destination_ports     = ["443"]
    destination_addresses = [azurerm_public_ip.redirect_firewall_public_ip.ip_address]
    translated_port       = 443
    translated_address    = var.dmz_vnet_gateway_public_ip_address
    protocols             = ["TCP"]
  }
} */


resource "azurerm_firewall_policy" "redirect_policy" {
  name                = "redirect-policy"
  resource_group_name = module.mod_rg.resource_group_name
  location            = module.mod_azure_region_lookup.location_cli
  sku                 = "Standard"
}

resource "azurerm_firewall_policy_rule_collection_group" "redirect_policy_rule_collection_group" {
  name               = "redirect-fwpolicy-rcg"
  firewall_policy_id = azurerm_firewall_policy.redirect_policy.id
  priority           = 100

  nat_rule_collection {
    name     = "redirect_nat_rule_collection"
    priority = 100
    action   = "Dnat"
    rule {
      name                = "redirect_nat_rule_collection_redirect_to_dmz"
      protocols           = ["TCP"]
      source_addresses    = ["*"]
      destination_address = azurerm_public_ip.redirect_firewall_public_ip.ip_address
      destination_ports   = ["443"]
      translated_address  = var.dmz_vnet_gateway_public_ip_address
      translated_port     = "443"
    }
  }
}

