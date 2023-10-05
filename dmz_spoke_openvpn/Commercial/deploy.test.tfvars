required = {
  org_name           = "anoa"
  deploy_environment = "dev"
  environment        = "public"
}

location      = "eastus"
workload_name = "openvpn"

dmz_subscription_id                             = "<< Enter your DMZ Subscription ID here >>"
hub_subscription_id                             = "<< Enter your DMZ Subscription ID here >>"
hub_virtual_network_name                        = "anoa-eus-hub-core-dev-vnet"
hub_resource_group_name                         = "anoa-eus-hub-core-dev-rg"
hub_firewall_name                               = "anoa-eus-hub-core-dev-fw"
hub_log_analytics_workspace_resource_group_name = "anoa-eus-ops-mgt-logging-dev-rg"
hub_log_analytics_workspace_name                = "anoa-eus-ops-mgt-logging-dev-log"


####################################################
#
#    DMZ Transport Spoke
#
####################################################

dmz_vnet_address_space = ["10.14.0.0/24"]
dmz_vnet_subnets = {
  untrusted = {
    name                                       = "untrusted"
    address_prefixes                           = ["10.14.0.0/27"]
    service_endpoints                          = ["Microsoft.Storage", "Microsoft.KeyVault"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true

    nsg_subnet_rules = [
      {
        name                       = "AllowAnyHTTPSInbound",
        description                = "Allow access to port 443",
        priority                   = 100,
        direction                  = "Inbound",
        access                     = "Allow",
        protocol                   = "*",
        source_port_range          = "*",
        destination_port_range     = "443",
        source_address_prefix      = "*",
        destination_address_prefix = "*"
      }
    ]
  }
  trusted = {
    name                                       = "trusted"
    address_prefixes                           = ["10.14.0.32/27"]
    service_endpoints                          = ["Microsoft.Storage", "Microsoft.KeyVault"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true

    nsg_subnet_rules = [
      {
        name                   = "AllowVPNClientTraffictoEnclave",
        description            = "Allow VPN Clients to access the networks in the Enclave.",
        priority               = 100,
        direction              = "Outbound",
        access                 = "Allow",
        protocol               = "*",
        source_port_range      = "*",
        destination_port_range = "*",
        source_address_prefix  = "10.3.0.0/16",
        destination_address_prefixes = [
          "10.8.0.0/16"
        ]
      }
    ]
  }
}


#############################################################
##
##  OpenVPN Servers
##
#############################################################
openvpn_client_address_prefix = "10.3.0.0/16"

kv_admin_group_object_id = "<< Object Id of AAD Group that you are a member of for KV access >>"
kv_ip_allow_list         = []

openvpn_server_vm_admin_username       = "azureuser"
openvpn_server_vm_ssh_public_key_path  = "~/.ssh/ovpn-server-vm.key.pub"
openvpn_server_vm_ssh_private_key_path = "~/.ssh/ovpn-server-vm.key"

openvpn_ca_root_cert_path                = "~/.ssh/openvpn/ca.crt"
openvpn_dh_cert_path                     = "~/.ssh/openvpn/dh.pem"
openvpn_server_public_key_path           = "~/.ssh/openvpn/osopenvpn.crt"
openvpn_server_private_key_path          = "~/.ssh/openvpn/osopenvpn.key"
openvpn_server_private_key_password_path = "~/.ssh/openvpn/osopenvpn.key.password"
openvpn_client_dns_server_address        = "10.8.4.68"



