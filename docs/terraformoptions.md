# Terraform Options

Configuration Terraform Options:

1. [General OCI](#general-oci)
2. [Network Parameters](#network-parameters)
3. [Bastion Host Parameters](#bastion-host-parameters)
4. [Tagging Parameters](#tagging-parameters)

## General OCI

| Parameter | Description | Values | Default |
| --- | --- | --- | --- |
| `compartment_id` | Compartment id where the bastion resources will be provisioned. Required. |  | None |
| `label_prefix` | A string to be prepended to the names of resources. | string | `none` |
| `assign_dns` | Whether to assign DNS records to created instances and subnet hostname labels. | `true` / `false` | `true` |

## Network Parameters

| Parameter | Description | Values | Default |
| --- | --- | --- | --- |
| `bastion_availability_domain` | The AD number used to place the bastion host. | number | `1` |
| `bastion_allowed_cidrs` | List of CIDR blocks allowed SSH access to the bastion. `anywhere` is equivalent to `0.0.0.0/0`. | list of CIDRs or `["anywhere"]` | `["anywhere"]` |
| `bastion_nsg_ids` | Additional NSG IDs to attach to the bastion VNIC. | list(string) | `[]` |
| `ig_route_id` | Route table ID for the bastion subnet when `bastion_is_public = true`. Required for public bastions. | string | `null` |
| `bastion_route_table_id` | Route table ID for the bastion subnet when `bastion_is_public = false`. Required for private bastions and must be unset for public bastions. | string | `null` |
| `netnum` | 0-based index of the bastion subnet when the VCN CIDR is masked with `newbits`. | number | `0` |
| `newbits` | Difference between the VCN netmask and the desired bastion subnet mask. | number | `14` |
| `vcn_id` | The VCN OCID used to create bastion resources. Required. | string | None |

## Bastion Host Parameters

| Parameter | Description | Values | Default |
| --- | --- | --- | --- |
| `bastion_user` | User for SSH access through the bastion host. | string | `opc` |
| `bastion_image_type` | Whether to use a platform or custom image. Custom images require `bastion_image_id` and must disable `bastion_await_cloudinit`. | `platform` / `custom` | `platform` |
| `bastion_image_id` | Custom image OCID when `bastion_image_type = "custom"`. | OCI image OCID | `null` |
| `bastion_image_os` | Platform image operating system name. Currently supported only for `Oracle Autonomous Linux`. | string | `Oracle Autonomous Linux` |
| `bastion_image_os_version` | Platform image operating system version. | string | `9` |
| `bastion_shape` | Shape configuration map. | map | `{ shape = "VM.Standard.E4.Flex", ocpus = 1, memory = 4, boot_volume_size = 50 }` |
| `bastion_state` | Target instance state. | `RUNNING` / `STOPPED` | `RUNNING` |
| `bastion_timezone` | Preferred timezone for the bastion host. | string | `Australia/Sydney` |
| `bastion_is_public` | Whether the bastion is provisioned with a public IP. | `true` / `false` | `true` |
| `ssh_public_key` | SSH public key content. Set this or `ssh_public_key_path`. | string | `""` |
| `ssh_private_key` | SSH private key content used only when waiting for cloud-init on a public bastion. | string | `null` |
| `ssh_public_key_path` | Path to the SSH public key. Set this or `ssh_public_key`. | string | `""` |
| `upgrade_bastion` | Whether to upgrade bastion packages after provisioning. | `true` / `false` | `false` |
| `bastion_await_cloudinit` | Whether Terraform should wait for SSH connectivity and cloud-init completion. Only attempted for public bastions and must be `false` for custom images. | `true` / `false` | `true` |

## Validation Rules

- `ig_route_id` must be set when `bastion_is_public = true`.
- `bastion_route_table_id` must be set when `bastion_is_public = false` and must be unset for public bastions.
- `bastion_image_type = "custom"` requires `bastion_image_id` and forces `bastion_await_cloudinit = false`.
- `bastion_image_type = "platform"` currently supports only `bastion_image_os = "Oracle Autonomous Linux"`.
- Either `ssh_public_key` or `ssh_public_key_path` must be provided.
- `ssh_private_key` is required only when `bastion_await_cloudinit = true` for a public bastion.

## Tagging Parameters

| Parameter | Description | Values | Default |
| --- | --- | --- | --- |
| `freeform_tags` | Freeform tags for bastion resources. | map(string) | `{ access = "public", environment = "dev", role = "bastion" }` |
