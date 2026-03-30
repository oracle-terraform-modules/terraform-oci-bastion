# Copyright 2019, 2026 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# Protocols are specified as protocol numbers.
# https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml

locals {
  all_protocols = "all"

  anywhere = "0.0.0.0/0"

  bastion_image_id = var.bastion_image_type == "custom" ? coalesce(var.bastion_image_id, "none") : try(data.oci_core_images.autonomous_images[0].images[0].id, "none")

  default_shape = "VM.Standard.E4.Flex"
  shape         = lookup(var.bastion_shape, "shape", local.default_shape)

  bastion_nsg_ids = distinct(concat([oci_core_network_security_group.bastion.id], var.bastion_nsg_ids))

  ssh_port = 22

  tcp_protocol = 6

  # we expect the bastion to be in the first cidr block in the list of cidr blocks
  vcn_cidr = element(data.oci_core_vcn.vcn.cidr_blocks, 0)
}
