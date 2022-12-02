# Copyright 2019, 2022 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

resource "oci_core_instance" "bastion" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_id
  freeform_tags       = var.freeform_tags

  agent_config {

    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false

    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }

  create_vnic_details {
    assign_public_ip = var.bastion_type == "public" ? true : false
    display_name     = var.label_prefix == "none" ? "bastion-vnic" : "${var.label_prefix}-bastion-vnic"
    hostname_label   = var.assign_dns ? "bastion" : null
    subnet_id        = oci_core_subnet.bastion.id
  }

  display_name = var.label_prefix == "none" ? "bastion" : "${var.label_prefix}-bastion"

  launch_options {
    boot_volume_type = "PARAVIRTUALIZED"
    network_type     = "PARAVIRTUALIZED"
  }

  # prevent the bastion from destroying and recreating itself if the image ocid changes 
  lifecycle {
    ignore_changes = [availability_domain, defined_tags, freeform_tags, metadata, source_details[0].source_id]
  }

  metadata = {
    ssh_authorized_keys = (var.ssh_public_key != "") ? var.ssh_public_key : (var.ssh_public_key_path != "none") ? file(var.ssh_public_key_path) : ""
    user_data           = var.bastion_image_id == "Autonomous" ? data.cloudinit_config.bastion.rendered : null
  }

  shape = local.shape

  dynamic "shape_config" {
    for_each = length(regexall("Flex", local.shape)) > 0 ? [1] : []
    content {
      ocpus         = max(1, lookup(var.bastion_shape, "ocpus", 1))
      memory_in_gbs = (lookup(var.bastion_shape, "memory", 4) / lookup(var.bastion_shape, "ocpus", 1)) > 64 ? (lookup(var.bastion_shape, "ocpus", 1) * 4) : lookup(var.bastion_shape, "memory", 4)
    }
  }

  source_details {
    boot_volume_size_in_gbs = lookup(var.bastion_shape, "boot_volume_size", 50)
    source_type             = "image"
    source_id               = local.bastion_image_id
  }

  state = var.bastion_state

  timeouts {
    create = "60m"
  }

}
