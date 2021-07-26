# Copyright 2019, 2020 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_id

  ad_number = var.availability_domain
}

data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.tenancy_id
}

# get the tenancy's home region
data "oci_identity_regions" "home_region" {
  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenancy.home_region_key]
  }
}

data "oci_core_vcn" "vcn" {
  vcn_id = var.vcn_id
}

data "oci_core_images" "autonomous_images" {
  compartment_id           = var.compartment_id
  operating_system         = "Oracle Autonomous Linux"
  operating_system_version = var.bastion_operating_system_version
  shape                    = lookup(var.bastion_shape, "shape", "VM.Standard.E2.2")
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# cloud init for bastion
data "template_cloudinit_config" "bastion" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "bastion.yaml"
    content_type = "text/cloud-config"
    content = templatefile(
      local.autonomous_template, {
        bastion_timezone        = var.bastion_timezone,
        notification_sh_content = local.notification_template,
        upgrade_bastion         = var.upgrade_bastion
      }
    )
  }
  count = var.create_bastion == true ? 1 : 0
}

# Gets a list of VNIC attachments on the bastion instance
data "oci_core_vnic_attachments" "bastion_vnics_attachments" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_id
  depends_on          = [oci_core_instance.bastion]
  instance_id         = oci_core_instance.bastion[0].id

  count = var.create_bastion == true ? 1 : 0
}

# Gets the OCID of the first (default) VNIC on the bastion instance
data "oci_core_vnic" "bastion_vnic" {
  depends_on = [oci_core_instance.bastion]
  vnic_id    = lookup(data.oci_core_vnic_attachments.bastion_vnics_attachments[0].vnic_attachments[0], "vnic_id")

  count = var.create_bastion == true ? 1 : 0
}

data "oci_core_instance" "bastion" {
  depends_on  = [oci_core_instance.bastion]
  instance_id = oci_core_instance.bastion[0].id

  count = var.create_bastion == true ? 1 : 0
}

data "oci_ons_notification_topic" "bastion_notification" {
  topic_id = oci_ons_notification_topic.bastion_notification[0].topic_id

  count = (var.create_bastion == true && var.enable_notification == true) ? 1 : 0
}
