required = {
  org_name           = "anoa"
  deploy_environment = "test"
  environment        = "public"
  metadata_host      = "management.azure.com"
}

location      = "uaenorth"
workload_name = "et-redir"



#---------------------------------------------------
#  Redirector Spoke Virtual Network
#---------------------------------------------------
virtual_network_address_space = ["10.102.0.0/16"]

redirector_spoke_subnets = {
  "default" = {
    name                                       = "default"
    address_prefixes                           = ["10.102.0.0/24"]
    service_endpoints                          = ["Microsoft.KeyVault"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true

    nsg_subnet_rules = [
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
    ]
  }
}
