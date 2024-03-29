# Copyright (c) 2019, 2021 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 4.67.3"
      # pass oci home region provider explicitly for identity operations
      configuration_aliases = [oci.home]
    }
  }
  required_version = ">= 1.0.0"
}
