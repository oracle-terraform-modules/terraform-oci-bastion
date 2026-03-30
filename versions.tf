# Copyright (c) 2019, 2026 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

terraform {
  required_providers {
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">= 2.3.0"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1"
    }

    oci = {
      source  = "oracle/oci"
      version = ">= 7.30.0"
    }
  }
  required_version = ">= 1.0.0"
}
