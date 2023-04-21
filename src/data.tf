data "terraform_remote_state" "lz" { 
    backend = "local" 
    config = { path = "../../mpe_management/src/modules/landing_zone/terraform.tfstate" } 
}

data "azurerm_subnet" "GatewaySubnet" {
  name                 = "GatewaySubnet"
  virtual_network_name = data.terraform_remote_state.lz.outputs.hub_virtual_network_name
  resource_group_name  = data.terraform_remote_state.lz.outputs.hub_resource_group_name
}

