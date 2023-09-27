module "mod_rg" {
  source  = "azurenoops/overlays-resource-group/azurerm"
  version = "~> 1.0"

  org_name                = var.required.org_name
  environment             = var.required.deploy_environment
  workload_name           = var.workload_name
  location                = module.mod_azure_region_lookup.location_full_name
  use_location_short_name = var.use_location_short_name
}