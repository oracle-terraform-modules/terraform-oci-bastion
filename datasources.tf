# Copyright 2019, 2026 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.compartment_id
  ad_number      = var.bastion_availability_domain
}

data "oci_core_vcn" "vcn" {
  vcn_id = var.vcn_id
}

data "oci_core_images" "autonomous_images" {
  count                    = var.bastion_image_type == "platform" ? 1 : 0
  compartment_id           = var.compartment_id
  operating_system         = var.bastion_image_os
  operating_system_version = var.bastion_image_os_version
  shape                    = lookup(var.bastion_shape, "shape", "VM.Standard.E2.2")
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# Gets a list of VNIC attachments on the bastion instance
data "oci_core_vnic_attachments" "bastion_vnics_attachments" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_id
  depends_on          = [oci_core_instance.bastion]
  instance_id         = oci_core_instance.bastion.id
}

# Gets the OCID of the first (default) VNIC on the bastion instance
data "oci_core_vnic" "bastion_vnic" {
  depends_on = [oci_core_instance.bastion]
  vnic_id    = lookup(data.oci_core_vnic_attachments.bastion_vnics_attachments.vnic_attachments[0], "vnic_id")
}
