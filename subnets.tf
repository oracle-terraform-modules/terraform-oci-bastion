# Copyright 2019, 2020 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

resource "oci_core_subnet" "bastion" {
  cidr_block                 = cidrsubnet(local.vcn_cidr, var.newbits, var.netnum)
  compartment_id             = var.compartment_id
  display_name               = var.label_prefix == "none" ? "bastion" : "${var.label_prefix}-bastion"
  dns_label                  = "bastion"
  freeform_tags              = var.tags
  prohibit_public_ip_on_vnic = false
  route_table_id             = var.ig_route_id
  security_list_ids          = [oci_core_security_list.bastion[0].id]
  vcn_id                     = var.vcn_id

  count = var.bastion_enabled == true ? 1 : 0
}
