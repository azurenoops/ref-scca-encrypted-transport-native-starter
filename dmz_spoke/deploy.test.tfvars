required = {
  org_name           = "anoa"
  deploy_environment = "dev"
  environment        = "public"
  metadata_host      = "management.azure.com"
}

location      = "eastus"
workload_name = "et-dmz"

dmz_subscription_id             = "c24647bf-0c86-4408-8d29-6a67262a2701"
hub_virtual_network_resource_id = "/subscriptions/c24647bf-0c86-4408-8d29-6a67262a2701/resourceGroups/anoa-eus-hub-core-dev-rg/providers/Microsoft.Network/virtualNetworks/anoa-eus-hub-core-dev-vnet"
hub_firewall_private_ip_address = "10.8.4.68"
hub_storage_account_resource_id = "/subscriptions/c24647bf-0c86-4408-8d29-6a67262a2701/resourceGroups/anoa-eus-hub-core-dev-rg/providers/Microsoft.Storage/storageAccounts/anoaeus3ba012f68bdevst"

log_analytics_workspace_resource_id = "/subscriptions/c24647bf-0c86-4408-8d29-6a67262a2701/resourceGroups/anoa-eus-ops-mgt-logging-dev-rg/providers/Microsoft.OperationalInsights/workspaces/anoa-eus-ops-mgt-logging-dev-log"
log_analytics_workspace_id          = "fe3746fa-5bf2-4e03-a03c-3bdd0e7af6f6"

####################################################
#
#    DMZ Transport Spoke
#
####################################################

dmz_vnet_address_space = ["10.2.0.0/24"]
dmz_vnet_subnets = {
  default = {
    name                                       = "default"
    address_prefixes                           = ["10.2.0.0/27"]
    service_endpoints                          = ["Microsoft.Storage", "Microsoft.KeyVault"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true

    nsg_subnet_rules = []
  }
  bgp_vm_subnet = {
    name                                       = "bgp_vm_subnet"
    address_prefixes                           = ["10.2.0.64/27"]
    service_endpoints                          = ["Microsoft.Storage", "Microsoft.KeyVault"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true

    nsg_subnet_rules = []
  }
}

####################################################
## VM Scale Set for BGP Configuration
####################################################

bgp_linux_vmss_vmsize               = "Standard_DS1_v2"
bgp_linux_vmss_admin_username       = "azureuser"
bgp_linux_vmss_ssh_public_key_path  = "~/.ssh/et-bgp-vmss-ssh-key.key.pub"
bgp_linux_vmss_ssh_private_key_path = "~/.ssh/et-bgp-vmss-ssh-key.key"
kv_admin_group_name                 = "ssj_vmss_admins"
kv_ip_allow_list                    = ["67.77.83.175"]



subnet_id = azurerm_subnet.hub1-subnets.id
//azure_monitor_agent_enabled = false

/* source_image_reference = {
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "18.04-LTS"
  version   = "latest"
}
 */


####################################################
#
#    Route Server 
#
####################################################

route_server_subnet_address_prefix = "10.2.0.96/27"
route_server_bgp_asn               = 43

##################################################
#
#   Virtual Network Gateway 
#
##################################################

vnet_gateway_sku                         = "VpnGw2"
vnet_gateway_subnet_address_prefixes     = ["10.2.0.32/27"]
vnet_gateway_vpn_client_address_prefixes = ["10.3.0.0/23"] //VpnGw2 SKU handles up to 500 connections
vnet_gateway_vpn_root_certificate_path   = "~/.ssh/VPN_ROOT_CERT.pem"


