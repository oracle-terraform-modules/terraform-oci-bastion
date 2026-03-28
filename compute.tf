# Copyright (c) 2019, 2026 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  boot_volume_size = tonumber(lookup(var.bastion_shape, "boot_volume_size", 50))
  memory           = tonumber(lookup(var.bastion_shape, "memory", 4))
  ocpus            = max(1, tonumber(lookup(var.bastion_shape, "ocpus", 1)))

  baseline_ocpu_utilization_map = {
    "12.5" = "BASELINE_1_8"
    "50"   = "BASELINE_1_2"
    "100"  = "BASELINE_1_1"
  }
  baseline_ocpu_utilization = lookup(local.baseline_ocpu_utilization_map, lookup(var.bastion_shape, "baseline_ocpu_utilization", "100"))
}

output "id" {
  value = oci_core_instance.bastion.id
}

output "public_ip" {
  value = oci_core_instance.bastion.public_ip
}

resource "oci_core_instance" "bastion" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_id
  display_name        = var.label_prefix == "none" ? "bastion" : "${var.label_prefix}-bastion"
  freeform_tags       = var.freeform_tags
  shape               = local.shape

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
    assign_public_ip = var.bastion_is_public
    display_name     = var.label_prefix == "none" ? "bastion-vnic" : "${var.label_prefix}-bastion-vnic"
    hostname_label   = var.assign_dns ? "bastion" : null
    nsg_ids          = local.bastion_nsg_ids
    subnet_id        = oci_core_subnet.bastion.id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key != "" ? var.ssh_public_key : (var.ssh_public_key_path != "" ? file(pathexpand(var.ssh_public_key_path)) : "")
    user_data           = var.bastion_image_type == "platform" ? data.cloudinit_config.bastion.rendered : null
  }

  dynamic "shape_config" {
    for_each = length(regexall("Flex", local.shape)) > 0 ? [1] : []
    content {
      baseline_ocpu_utilization = local.baseline_ocpu_utilization
      ocpus                     = local.ocpus
      memory_in_gbs             = (local.memory / local.ocpus) > 64 ? (local.ocpus * 4) : local.memory
    }
  }

  source_details {
    boot_volume_size_in_gbs = local.boot_volume_size
    source_id               = local.bastion_image_id
    source_type             = "image"
  }

  lifecycle {
    ignore_changes = [
      availability_domain,
      freeform_tags, metadata, source_details[0].source_id,
    ]

    precondition {
      condition     = local.bastion_image_id != "none"
      error_message = "Missing image_id for bastion. Check provided value for image_id if image_type is 'custom', or image_os/image_os_version if image_type is 'platform'."
    }
  }

  state = var.bastion_state

  timeouts {
    create = "60m"
  }
}
