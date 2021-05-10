# Copyright 2019, 2020 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

resource "oci_core_security_list" "bastion" {
  compartment_id = var.compartment_id
  display_name   = var.label_prefix == "none" ? "bastion" : "${var.label_prefix}-bastion"
  freeform_tags  = var.tags

  egress_security_rules {
    protocol    = local.all_protocols
    destination = local.anywhere
  }

  ingress_security_rules {
    # allow ssh
    protocol = local.tcp_protocol
    source   = var.bastion_access == "ANYWHERE" ? local.anywhere : var.bastion_access

    tcp_options {
      min = local.ssh_port
      max = local.ssh_port
    }
  }
  vcn_id = var.vcn_id

  count = var.bastion_enabled == true ? 1 : 0
}
