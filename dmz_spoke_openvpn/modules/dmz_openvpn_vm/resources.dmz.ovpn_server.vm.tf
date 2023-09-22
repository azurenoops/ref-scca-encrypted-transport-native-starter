####################################
#
#    OpenVPN Server VM
#
####################################

resource "azurerm_public_ip" "ovpn-server-vm-pip" {
  name                = data.azurenoopsutils_resource_name.ovpn-server-vm-pip.result
  location            = module.mod_azure_region_lookup.location_cli
  resource_group_name = var.openvpn_server_vm_resource_group_name
  allocation_method   = "Static"
}


resource "azurerm_network_interface" "ovpn-server-vm-nic-untrusted" {
  name                 = data.azurenoopsutils_resource_name.ovpn-server-vm-nic-untrusted.result
  location             = module.mod_azure_region_lookup.location_cli
  resource_group_name  = var.openvpn_server_vm_resource_group_name
  enable_ip_forwarding = true
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "ovpn-server-vm-nic-untrusted-ipconfig"
    subnet_id                     = data.azurerm_subnet.untrusted.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.untrusted_nic_ip_address
    public_ip_address_id          = azurerm_public_ip.ovpn-server-vm-pip.id
  }
}

resource "azurerm_network_interface" "ovpn-server-vm-nic-trusted" {
  name                 = data.azurenoopsutils_resource_name.ovpn-server-vm-nic-trusted.result
  location             = module.mod_azure_region_lookup.location_cli
  resource_group_name  = var.openvpn_server_vm_resource_group_name
  enable_ip_forwarding = true
  enable_accelerated_networking = true
  
  ip_configuration {
    name                          = "ovpn-server-vm-nic-trusted-ipconfig"
    subnet_id                     = data.azurerm_subnet.trusted.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.trusted_nic_ip_address
  }
}

resource "azurerm_linux_virtual_machine" "ovpn-server-vm" {
  depends_on          = [module.dmz_keyvault]
  name                = data.azurenoopsutils_resource_name.ovpn_server_vm.result
  location            = module.mod_azure_region_lookup.location_cli
  resource_group_name = var.openvpn_server_vm_resource_group_name
  computer_name       = var.openvpn_server_vm_name
  size                = var.openvpn_server_vm_size
  admin_username      = var.openvpn_server_vm_admin_username

  custom_data = data.template_cloudinit_config.openvpn_config.rendered

  admin_ssh_key {
    username   = var.openvpn_server_vm_admin_username
    public_key = file(var.openvpn_server_vm_ssh_public_key_path)
  }

  network_interface_ids = [
    azurerm_network_interface.ovpn-server-vm-nic-untrusted.id,
    azurerm_network_interface.ovpn-server-vm-nic-trusted.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.openvpn_server_image_publisher
    offer     = var.openvpn_server_image_offer
    sku       = var.openvpn_server_image_sku
    version   = "latest"
  }
}

###################################
#
#    Load SSH Key into KeyVault
#      and set permissions so 
#      admins can access it
#
###################################

resource "azurerm_key_vault_secret" "ovpn-server-ssh-key" {
  depends_on   = [module.dmz_keyvault]
  name         = "OpenVPNServerVM-SSH-Key"
  value        = file(var.openvpn_server_vm_ssh_private_key_path)
  key_vault_id = module.dmz_keyvault.key_vault_id
}


