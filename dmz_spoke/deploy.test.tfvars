required = {
  org_name           = "anoa"
  deploy_environment = "test"
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

dmz_vnet_address_space = ["10.2.0.0/16"]
dmz_vnet_subnets = {
  dmz = {
    name                                       = "dmz"
    address_prefixes                           = ["10.2.0.0/27"]
    service_endpoints                          = ["Microsoft.Storage", "Microsoft.KeyVault"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true

    nsg_subnet_rules = []
    /* nsg_subnet_rules = [
      {
        name                       = "allow-443",
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
    ] */

  }
}


####################################################
#
#    Route Server 
#
####################################################

route_server_subnet_address_prefix = "10.2.1.0/24"



