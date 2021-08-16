# Copyright (c) 2019, 2021 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

provider "oci" {
  fingerprint      = var.api_fingerprint
  private_key_path = var.api_private_key_path
  region           = var.region
  tenancy_ocid     = var.tenancy_id
  user_ocid        = var.user_id
}

provider "oci" {
  fingerprint      = var.api_fingerprint
  private_key_path = var.api_private_key_path
  region           = var.region
  tenancy_ocid     = var.tenancy_id
  user_ocid        = var.user_id
  alias            = "home"
}

module "bastion" {
  source = "../terraform-oci-bastion"
  tenancy_id     = var.tenancy_id
  compartment_id = var.compartment_id

  label_prefix   = var.label_prefix

  availability_domain = var.availability_domain

  ig_route_id = var.ig_route_id

  netnum = var.netnum

  newbits = var.newbits

  vcn_id = "ocid1.vcn.."

  create_bastion_host = true

  ssh_public_key_path = "~/.ssh/id_rsa.pub"

  upgrade_bastion = false

  bastion_tags = {
    access      = "public"
    environment = "dev"
    role        = "bastion"
  }

  providers = {
      oci.home = oci.home
  }
}
