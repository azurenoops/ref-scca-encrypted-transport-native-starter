# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# remove file if not needed

#---------------------------------
# Local declarations
#---------------------------------
# The following block of locals are used to avoid using
# empty object types in the code
locals {
  empty_list   = []
  empty_map    = tomap({})
  empty_string = ""
}

#---------------------------------
# Random ID
#---------------------------------
resource "random_id" "uniqueString" {
  keepers = {
    # Generate a new id each time we change resourePrefix variable
    org_prefix = var.required.org_name
    subid      = var.workload_name
  }
  byte_length = 8
}


