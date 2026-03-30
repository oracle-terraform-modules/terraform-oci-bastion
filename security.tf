# Copyright 2019, 2026 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

resource "oci_core_security_list" "bastion" {
  compartment_id = var.compartment_id
  display_name   = var.label_prefix == "none" ? "bastion" : "${var.label_prefix}-bastion"
  freeform_tags  = var.freeform_tags

  lifecycle {
    ignore_changes = [freeform_tags]
  }

  vcn_id = var.vcn_id
}

resource "oci_core_network_security_group" "bastion" {
  compartment_id = var.compartment_id
  display_name   = var.label_prefix == "none" ? "bastion" : "${var.label_prefix}-bastion"
  freeform_tags  = var.freeform_tags
  vcn_id         = var.vcn_id

  lifecycle {
    ignore_changes = [freeform_tags]
  }
}

resource "oci_core_network_security_group_security_rule" "bastion_ingress_ssh" {
  for_each                  = toset([for cidr in var.bastion_allowed_cidrs : cidr == "anywhere" ? local.anywhere : cidr])
  description               = "Allow SSH ingress to bastion from ${each.value}"
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.bastion.id
  protocol                  = local.tcp_protocol
  source                    = each.value
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = local.ssh_port
      max = local.ssh_port
    }
  }
}

resource "oci_core_network_security_group_security_rule" "bastion_egress_all" {
  description               = "Allow all egress from bastion"
  direction                 = "EGRESS"
  network_security_group_id = oci_core_network_security_group.bastion.id
  protocol                  = local.all_protocols
  destination               = local.anywhere
  destination_type          = "CIDR_BLOCK"
}
