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

  dynamic "ingress_security_rules" {
    # allow ssh

    for_each = var.bastion_access
    iterator = bastion_access_iterator
    content {
      protocol = local.tcp_protocol
      source   = bastion_access_iterator.value == "anywhere" ? local.anywhere : bastion_access_iterator.value

      tcp_options {
        min = local.ssh_port
        max = local.ssh_port
      }
    }
  }
  vcn_id = var.vcn_id

  count = var.create_bastion_host == true ? 1 : 0
}
