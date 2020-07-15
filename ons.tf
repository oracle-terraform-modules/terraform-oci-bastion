# Copyright 2019, 2020 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

provider "oci" {
  alias            = "home"
  fingerprint      = var.api_fingerprint
  private_key_path = var.api_private_key_path
  region           = lookup(data.oci_identity_regions.home_region.regions[0], "name")
  tenancy_ocid     = var.tenancy_id
  user_ocid        = var.user_id
}

resource "oci_ons_notification_topic" "bastion_notification" {
  compartment_id = var.compartment_id
  name           = var.label_prefix == "none" ? var.notification_topic : "${var.label_prefix}-${var.notification_topic}"

  count = (var.bastion_enabled == true && var.notification_enabled == true) ? 1 : 0
}

resource "oci_ons_subscription" "bastion_notification" {
  compartment_id = var.compartment_id
  endpoint       = var.notification_endpoint
  protocol       = var.notification_protocol
  topic_id       = oci_ons_notification_topic.bastion_notification[0].topic_id

  count = (var.bastion_enabled == true && var.notification_enabled == true) ? 1 : 0
}

resource "oci_identity_dynamic_group" "bastion_notification" {
  provider = oci.home

  compartment_id = var.tenancy_id
  depends_on     = [oci_core_instance.bastion]
  description    = "dynamic group to allow bastion to send notifications to ONS"
  matching_rule  = "ALL {instance.id = '${join(",", data.oci_core_instance.bastion.*.id)}'}"
  name           = var.label_prefix == "none" ? "bastion-notification" : "${var.label_prefix}-bastion-notification"

  count = (var.bastion_enabled == true && var.notification_enabled == true) ? 1 : 0
}

resource "oci_identity_policy" "bastion_notification" {
  provider = oci.home

  compartment_id = var.compartment_id
  depends_on     = [oci_core_instance.bastion]
  description    = "policy to allow bastion host to publish messages to ONS"
  name           = var.label_prefix == "none" ? "bastion-notification" : "${var.label_prefix}-bastion-notification"
  statements     = ["Allow dynamic-group ${oci_identity_dynamic_group.bastion_notification[0].name} to use ons-topic in compartment id ${var.compartment_id} where request.permission='ONS_TOPIC_PUBLISH'"]

  count = (var.bastion_enabled == true && var.notification_enabled == true) ? 1 : 0
}
