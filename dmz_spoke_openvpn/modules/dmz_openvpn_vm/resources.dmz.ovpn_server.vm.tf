####################################
#
#    OpenVPN Server VM
#
####################################

resource "azurerm_public_ip" "ovpn-server-vm-pip" {
  name                = data.azurenoopsutils_resource_name.ovpn-server-vm-pip.result
  location            = module.mod_azure_region_lookup.location_cli
  resource_group_name = var.openvpn_server_vm_resource_group_name
  allocation_method   = "Dynamic"
}


resource "azurerm_network_interface" "ovpn-server-vm-nic-untrusted" {
  name                = data.azurenoopsutils_resource_name.ovpn-server-vm-nic-untrusted.result
  location            = module.mod_azure_region_lookup.location_cli
  resource_group_name = var.openvpn_server_vm_resource_group_name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "ovpn-server-vm-nic-untrusted-ipconfig"
    subnet_id                     = var.openvpn_untrusted_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ovpn-server-vm-pip.id
  }
}

resource "azurerm_network_interface" "ovpn-server-vm-nic-trusted" {
  name                = data.azurenoopsutils_resource_name.ovpn-server-vm-nic-trusted.result
  location            = module.mod_azure_region_lookup.location_cli
  resource_group_name = var.openvpn_server_vm_resource_group_name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "ovpn-server-vm-nic-trusted-ipconfig"
    subnet_id                     = var.openvpn_trusted_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "ovpn-server-vm" {
  name                = data.azurenoopsutils_resource_name.ovpn_server_vm.result
  location            = module.mod_azure_region_lookup.location_cli
  resource_group_name = var.openvpn_server_vm_resource_group_name
  computer_name       = var.openvpn_server_vm_name
  size                = var.openvpn_server_vm_size
  admin_username      = var.openvpn_server_vm_admin_username

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

    # Use custom TAK scripts to install TAK Server on the VM.
/*   custom_data = base64encode(templatefile("${path.module}/scripts/cloud-init.sh",
    {
      CERT_STATE               = var.cert_state
      CERT_CITY                = var.cert_city
      CERT_ORGANIZATION        = var.cert_org
      CERT_ORGANIZATIONAL_UNIT = var.cert_org_unit
      CERT_USERS               = var.cert_users
      CERT_CAPASS              = random_password.ca_passwd.result
      SA_PASSWD                = var.sa_passwd
      SAS_CONNECTION           = data.azurerm_storage_account_sas.example.sas
      VAULT_NAME               = azurerm_key_vault.vm.name
      SUBSCRIPTION             = data.azurerm_subscription.current.subscription_id
      SA_URL_PREFIX            = var.sa_url_prefix
      TAK_PACKAGE_DEB          = var.tak_package_deb
      TAK_PACKAGE_RPM          = var.tak_package_rpm
    }
  )) */

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


