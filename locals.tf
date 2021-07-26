# Copyright 2019, 2020 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# Protocols are specified as protocol numbers.
# https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml

locals {
  all_protocols       = "all"
  
  anywhere            = "0.0.0.0/0"
  
  autonomous_template = "${path.module}/cloudinit/autonomous.template.yaml"
  
  bastion_image_id    = var.bastion_image_id == "Autonomous" ? data.oci_core_images.autonomous_images.images.0.id : var.bastion_image_id
  
  notification_template = base64gzip(
    templatefile("${path.module}/scripts/notification.template.sh",
      {
        enable_notification = var.enable_notification
        topic_id            = var.enable_notification == true ? oci_ons_notification_topic.bastion_notification[0].topic_id : "null"
      }
    )
  )
  
  ssh_port     = 22
  
  tcp_protocol = 6
  
  vcn_cidr     = data.oci_core_vcn.vcn.cidr_block
}
