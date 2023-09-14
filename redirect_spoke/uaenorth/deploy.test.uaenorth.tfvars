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

redirector_spoke_subnets = {}

firewall_subnet_address_prefixes   = ["10.102.1.0/24"]
dmz_vnet_gateway_public_ip_address = "104.45.141.121"



