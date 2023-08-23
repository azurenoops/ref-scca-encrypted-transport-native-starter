###############################
## Key Vault Configuration  ###
###############################
module "dmz_keyvault" {
  source  = "azurenoops/overlays-key-vault/azurerm"
  version = "~> 1.0"

  depends_on = [azurerm_private_dns_zone.dns_zone]

  # By default, this module will create a resource group and 
  # provide a name for an existing resource group. If you wish 
  # to use an existing resource group, change the option 
  # to "create_key_vault_resource_group = false."   
  existing_resource_group_name = var.dmz_resource_group_name
  location                     = module.mod_azure_region_lookup.location_cli
  deploy_environment           = var.required.deploy_environment
  org_name                     = var.required.org_name
  environment                  = var.required.environment
  workload_name                = var.workload_name

  # This is to enable the features of the key vault
  enabled_for_deployment          = var.kv_enabled_for_deployment
  enabled_for_disk_encryption     = var.kv_enabled_for_disk_encryption
  enabled_for_template_deployment = var.kv_enabled_for_template_deployment
  enable_purge_protection         = false
  public_network_access_enabled   = true

  # This is to enable the network access to the key vault
  network_acls = {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = var.kv_ip_allow_list
    virtual_network_subnet_ids = [var.kv_subnet_id]
  }

  # Creating Private Endpoint requires, VNet name to create a Private Endpoint
  # By default this will create a `privatelink.vaultcore.azure.net` DNS zone. if created in commercial cloud
  # To use existing subnet, specify `existing_subnet_id` with valid subnet id. 
  # To use existing private DNS zone specify `existing_private_dns_zone` with valid zone name
  # Private endpoints doesn't work If not using `existing_subnet_id` to create key vault inside a specified VNet.
  enable_private_endpoint   = var.enable_kv_private_endpoint
  existing_subnet_id        = var.kv_subnet_id
  existing_vnet_id          = data.azurerm_virtual_network.dmz_vnet.id
  existing_private_dns_zone = azurerm_private_dns_zone.dns_zone.name
  virtual_network_name      = data.azurerm_virtual_network.dmz_vnet.name
 

  # Current user should be here to be able to create keys and secrets
  admin_objects_ids = [
    var.kv_admin_group_id
  ]
}



###################################
## Key Vault DNS Configuration  ###
###################################
resource "azurerm_private_dns_zone" "dns_zone" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.dmz_resource_group_name
  tags                = merge({ "Name" = format("%s", "Azure-Key-Vault-Private-DNS-Zone") }, local.workload_resources_tags, )
}
