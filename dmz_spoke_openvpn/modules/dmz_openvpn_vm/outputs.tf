output "openvpn_vm_name"{
    value = azurerm_linux_virtual_machine.ovpn-server-vm.name
}

output "openvpn_public_ip_address" {
    value = azurerm_public_ip.ovpn-server-vm-pip.ip_address
}