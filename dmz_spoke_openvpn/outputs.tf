output "openvpn_vm_name" {
    description = "The name of the OpenVPN server VM"
    value       = module.openvpn.openvpn_vm_name
}

output "openvpn_public_ip" {
    description = "The public IP address of the OpenVPN server"
    value       = module.openvpn.openvpn_public_ip_address
}
