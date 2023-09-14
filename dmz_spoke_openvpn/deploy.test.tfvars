required = {
  org_name           = "anoa"
  deploy_environment = "dev"
  environment        = "public"
  metadata_host      = "management.azure.com"
}

location      = "eastus"
workload_name = "openvpn"

dmz_subscription_id                             = "c24647bf-0c86-4408-8d29-6a67262a2701"
hub_virtual_network_name                        = "anoa-eus-hub-core-dev-vnet"
hub_resource_group_name                         = "anoa-eus-hub-core-dev-rg"
hub_firewall_name                               = "anoa-eus-hub-core-dev-fw"
hub_storage_account_name                        = "anoaeus3ba012f68bdevst"
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

    nsg_subnet_rules = []
  }
}

#############################################################
##
##  OpenVPN Servers
##
#############################################################


kv_admin_group_name = "ssj-ovpn-admins"
kv_ip_allow_list    = ["67.77.83.175"]

openvpn_server_vm_admin_username       = "azureuser"
openvpn_server_vm_ssh_public_key_path  = "~/.ssh/ovpn-server-vm.key.pub"
openvpn_server_vm_ssh_private_key_path = "~/.ssh/ovpn-server-vm.key"


