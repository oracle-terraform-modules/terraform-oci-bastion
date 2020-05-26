# Copyright 2019, 2020 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

resource "oci_core_instance" "bastion" {
  availability_domain = element(local.ad_names, (var.availability_domain - 1))
  compartment_id      = var.compartment_id
  freeform_tags       = var.tags   

  create_vnic_details {
    assign_public_ip = true
    display_name     = "${var.label_prefix}-bastion-vnic"
    hostname_label   = "bastion"
    subnet_id        = oci_core_subnet.bastion[0].id
  }

  display_name = "${var.label_prefix}-bastion"

  # prevent the bastion from destroying and recreating itself if the image ocid changes 
  lifecycle {
    ignore_changes = [source_details[0].source_id]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key != "" ? var.ssh_public_key : file(var.ssh_public_key_path)
    user_data           = data.template_cloudinit_config.bastion[0].rendered
  }

  shape = var.bastion_shape

  source_details {
    source_type = "image"
    source_id   = local.bastion_image_id
  }

  timeouts {
    create = "60m"
  }

  count = var.bastion_enabled == true ? 1 : 0
}
