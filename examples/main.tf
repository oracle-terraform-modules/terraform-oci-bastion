# Copyright (c) 2019, 2026 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

provider "oci" {
  fingerprint      = var.api_fingerprint
  private_key_path = var.api_private_key_path
  region           = var.region
  tenancy_ocid     = var.tenancy_id
  user_ocid        = var.user_id
}

module "bastion" {
  source         = "../"
  compartment_id = var.compartment_id

  label_prefix = var.label_prefix

  ig_route_id = var.ig_route_id

  vcn_id = var.vcn_id

  bastion_image_type = "platform"
  bastion_image_os   = "Oracle Autonomous Linux"

  bastion_await_cloudinit = true
  ssh_private_key         = file(pathexpand("~/.ssh/id_rsa"))
  ssh_public_key_path     = "~/.ssh/id_rsa.pub"

  upgrade_bastion = false

  freeform_tags = {
    access      = "public"
    environment = "dev"
    role        = "bastion"
  }
}
