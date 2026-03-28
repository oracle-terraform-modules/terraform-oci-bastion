# Copyright (c) 2019, 2026 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

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

variable "assign_dns" {
  default     = true
  description = "Whether to assign DNS records to created instances"
  type        = bool
}

# network parameters
variable "bastion_availability_domain" {
  description = "the AD to place the bastion host"
  default     = 1
  type        = number
}

variable "bastion_allowed_cidrs" {
  description = "A list of CIDR blocks to which ssh access to the bastion must be restricted to. *anywhere* is equivalent to 0.0.0.0/0 and allows ssh access from anywhere."
  default     = ["anywhere"]
  type        = list(string)
  validation {
    condition = alltrue([
      for cidr in var.bastion_allowed_cidrs : lower(cidr) == "anywhere" || can(cidrnetmask(cidr))
    ])
    error_message = "Each bastion_allowed_cidrs entry must be a valid IPv4 CIDR or the literal 'anywhere'."
  }
}

variable "bastion_nsg_ids" {
  description = "An additional list of network security group (NSG) IDs for bastion security."
  default     = []
  type        = list(string)
}

variable "ig_route_id" {
  description = "the route id to the internet gateway"
  default     = null
  type        = string
  validation {
    condition     = !var.bastion_is_public || length(trimspace(coalesce(var.ig_route_id, ""))) > 0
    error_message = "ig_route_id must be provided when bastion_is_public is true."
  }
}

variable "bastion_route_table_id" {
  description = "Route table ID to associate with the bastion subnet. Required when bastion_is_public is false."
  default     = null
  type        = string
  validation {
    condition     = var.bastion_is_public ? length(trimspace(coalesce(var.bastion_route_table_id, ""))) == 0 : length(trimspace(coalesce(var.bastion_route_table_id, ""))) > 0
    error_message = "bastion_route_table_id must be unset for public bastions and provided for private bastions."
  }
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
variable "bastion_user" {
  default     = "opc"
  description = "User for SSH access through bastion host."
  type        = string
}

variable "bastion_image_id" {
  description = "Custom image OCID for the bastion host when bastion_image_type is set to custom."
  default     = null
  type        = string
  validation {
    condition     = var.bastion_image_type != "custom" || can(regex("^ocid1\\.image\\.", coalesce(var.bastion_image_id, "")))
    error_message = "bastion_image_id must be a valid image OCID when bastion_image_type is 'custom'."
  }
}

variable "bastion_image_type" {
  default     = "platform"
  description = "Whether to use a platform or custom image for the created bastion instance. When custom is set, the bastion_image_id must be specified."
  type        = string
  validation {
    condition     = contains(["custom", "platform"], var.bastion_image_type)
    error_message = "Accepted values are custom or platform"
  }
  validation {
    condition     = var.bastion_image_type != "custom" || !var.bastion_await_cloudinit
    error_message = "bastion_await_cloudinit must be false when bastion_image_type is 'custom'."
  }
}

variable "bastion_image_os" {
  default     = "Oracle Autonomous Linux"
  description = "Bastion image operating system name when bastion_image_type = 'platform'."
  type        = string
  validation {
    condition     = var.bastion_image_type != "platform" || var.bastion_image_os == "Oracle Autonomous Linux"
    error_message = "Platform image mode currently supports only Oracle Autonomous Linux."
  }
}

variable "bastion_image_os_version" {
  description = "Operating system version when bastion_image_type is set to platform."
  default     = "9"
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
  validation {
    condition     = contains(["RUNNING", "STOPPED"], var.bastion_state)
    error_message = "bastion_state must be RUNNING or STOPPED."
  }
}

variable "bastion_timezone" {
  description = "The preferred timezone for the bastion host."
  default     = "Australia/Sydney"
  type        = string
}

variable "bastion_is_public" {
  description = "Whether to make the bastion host public or private."
  default     = true
  type        = bool
}

variable "ssh_public_key" {
  description = "the content of the ssh public key used to access the bastion. set this or the ssh_public_key_path"
  default     = ""
  type        = string
  validation {
    condition     = length(trimspace(var.ssh_public_key)) > 0 || length(trimspace(var.ssh_public_key_path)) > 0
    error_message = "Either ssh_public_key or ssh_public_key_path must be provided."
  }
}

variable "ssh_private_key" {
  description = "Private key content used only when waiting for cloud-init over SSH on a public bastion."
  default     = null
  type        = string
  sensitive   = true
  validation {
    condition     = !(var.bastion_await_cloudinit && var.bastion_is_public) || length(trimspace(coalesce(var.ssh_private_key, ""))) > 0
    error_message = "ssh_private_key must be provided when bastion_await_cloudinit is true for a public bastion."
  }
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

variable "bastion_await_cloudinit" {
  default     = true
  description = "Whether to block until successful SSH connection to the bastion and completion of cloud-init. This wait path is only attempted for public bastions."
  type        = bool
}

# tagging
variable "freeform_tags" {
  description = "Freeform tags for bastion"
  default = {
    access      = "public"
    environment = "dev"
    role        = "bastion"
  }
  type = map(string)
}
