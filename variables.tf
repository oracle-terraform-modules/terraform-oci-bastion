# Copyright (c) 2019, 2021 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# provider parameters
variable "tenancy_id" {
  description = "tenancy id where to create the sources"
  type        = string
  default     = ""
}

# general oci parameters
variable "compartment_id" {
  description = "compartment id where to create all resources"
  type        = string
}

variable "label_prefix" {
  description = "a string that will be prepended to all resources"
  type        = string
  default     = "none"
}

# network parameters
variable "availability_domain" {
  description = "the AD to place the bastion host"
  default     = 1
  type        = number
}

variable "bastion_access" {
  description = "A list of CIDR blocks to which ssh access to the bastion must be restricted to. *anywhere* is equivalent to 0.0.0.0/0 and allows ssh access from anywhere."
  default     = ["anywhere"]
  type        = list
}

variable "ig_route_id" {
  description = "the route id to the internet gateway"
  type        = string
}

variable "netnum" {
  description = "0-based index of the bastion subnet when the VCN's CIDR is masked with the corresponding newbit value."
  default     = 0
  type        = number
}

variable "newbits" {
  description = "The difference between the VCN's netmask and the desired bastion subnet mask"
  default     = 14
  type        = number
}

variable "vcn_id" {
  description = "The id of the VCN to use when creating the bastion resources."
  type        = string
}

# bastion host parameters

variable "create_bastion_host" {
  description = "Whether to create the bastion host."
  default     = false
  type        = bool
}

variable "bastion_image_id" {
  description = "Provide a custom image id for the bastion host or leave as Autonomous."
  default     = "Autonomous"
  type        = string
}

variable "bastion_os_version" {
  description = "In case Autonomous Linux is used, allow specification of Autonomous version"
  default     = "7.9"
  type        = string
}

variable "bastion_shape" {
  description = "The shape of bastion instance."
  default = {
    shape = "VM.Standard.E4.Flex", ocpus = 1, memory = 4, boot_volume_size = 50
  }
  type = map(any)
}

variable "bastion_state" {
  description = "The target state for the instance. Could be set to RUNNING or STOPPED. (Updatable)"
  default     = "RUNNING"
  type        = string
}

variable "bastion_timezone" {
  description = "The preferred timezone for the bastion host."
  default     = "Australia/Sydney"
  type        = string
}

variable "bastion_type" {
  description = "Whether to make the bastion host public or private."
  default     = "public"
  type        = string
}

variable "ssh_public_key" {
  description = "the content of the ssh public key used to access the bastion. set this or the ssh_public_key_path"
  default     = ""
  type        = string
}

variable "ssh_public_key_path" {
  description = "path to the ssh public key used to access the bastion. set this or the ssh_public_key"
  default     = ""
  type        = string
}

variable "upgrade_bastion" {
  description = "Whether to upgrade the bastion host packages after provisioning. It's useful to set this to false during development/testing so the bastion is provisioned faster."
  default     = false
  type        = bool
}

# bastion notification
variable "enable_bastion_notification" {
  description = "Whether to enable ONS notification for the bastion host."
  default     = false
  type        = bool
}

variable "bastion_notification_endpoint" {
  description = "The subscription notification endpoint. Email address to be notified."
  default     = null
  type        = string
}

variable "bastion_notification_protocol" {
  description = "The notification protocol used."
  default     = "EMAIL"
  type        = string
}

variable "bastion_notification_topic" {
  description = "The name of the notification topic"
  default     = "bastion"
  type        = string
}

# tagging
variable "bastion_tags" {
  description = "Freeform tags for bastion"
  default = {
    access      = "public"
    environment = "dev"
    role        = "bastion"
  }
  type = map(any)
}
