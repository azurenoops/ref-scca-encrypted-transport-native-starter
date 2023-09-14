required = {
  org_name           = "anoa"
  deploy_environment = "dev"
  environment        = "public"
}

location      = "southafricanorth"
workload_name = "et-redir2"



#---------------------------------------------------
#  Redirector Spoke Virtual Network
#---------------------------------------------------
virtual_network_address_space               = ["10.103.0.0/16"]
redirector_spoke_subnets                    = {}
firewall_subnet_address_prefixes            = ["10.103.1.0/24"]
dmz_vnet_gateway_public_ip_address          = "52.226.135.92"

