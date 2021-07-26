# Copyright 2019, 2020 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

resource "oci_core_instance" "bastion" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_id
  freeform_tags       = var.tags

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
    hostname_label   = "bastion"
    subnet_id        = oci_core_subnet.bastion[0].id
  }

  display_name = var.label_prefix == "none" ? "bastion" : "${var.label_prefix}-bastion"

  launch_options {
    boot_volume_type = "PARAVIRTUALIZED"
    network_type     = "PARAVIRTUALIZED"
  }

  # prevent the bastion from destroying and recreating itself if the image ocid changes 
  lifecycle {
    ignore_changes = [source_details[0].source_id]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key != "" ? var.ssh_public_key : file(var.ssh_public_key_path)
    user_data           = data.template_cloudinit_config.bastion[0].rendered
  }

  shape = lookup(var.bastion_shape, "shape", "VM.Standard.E2.2")

  dynamic "shape_config" {
    for_each = length(regexall("Flex", lookup(var.bastion_shape, "shape", "VM.Standard.E3.Flex"))) > 0 ? [1] : []
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

  count = var.create_bastion == true ? 1 : 0
}
