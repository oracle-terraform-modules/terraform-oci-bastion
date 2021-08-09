# Copyright 2019, 2021 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

output "bastion_public_ip" {
  value = join(",", var.bastion_type == "public" ? data.oci_core_vnic.bastion_vnic.*.public_ip_address : data.oci_core_vnic.bastion_vnic.*.private_ip_address )
}