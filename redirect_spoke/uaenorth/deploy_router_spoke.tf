# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy an Redirector Spoke for Encrypted Transport into an SCCA Compliant Environment
DESCRIPTION: The following components will be options in this deployment
             * Redirector Spoke Network Architecture
AUTHOR/S: sstjean
*/

################################
### Redirector Spoke Configuations  ###
################################

module "redirector_spoke" {
  source = "../modules/redirector_spoke"

  required      = var.required
  workload_name = var.workload_name
  location      = var.location


  #------------------------------------------------
  #  Virtual Network Configuration
  #------------------------------------------------
  virtual_network_address_space = var.virtual_network_address_space
  redirector_spoke_subnets      = var.redirector_spoke_subnets

}
