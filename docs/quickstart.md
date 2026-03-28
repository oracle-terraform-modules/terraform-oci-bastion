# Quickstart

1. [Assumptions](#assumptions)
2. [Pre-requisites](#pre-requisites)
3. [Instructions](#instructions)
4. [Related documentation](#related-documentation)

### Assumptions

1. You have set up the [required keys](https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm).
2. You know the [required OCIDs](https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#five).
3. You have the necessary permissions.

### Pre-requisites

1. `git` is installed.
2. An SSH client is installed.
3. Terraform 1.0.0+ is installed.

### Instructions

#### Provisioning using this git repo

1. Clone the repo:

```bash
git clone https://github.com/oracle-terraform-modules/terraform-oci-bastion.git tfbastion

cd tfbastion

cp terraform.tfvars.example terraform.tfvars
```

2. Create a `provider.tf` file and add the following:

```hcl
provider "oci" {
  tenancy_ocid     = var.tenancy_id
  user_ocid        = var.user_id
  fingerprint      = var.api_fingerprint
  private_key_path = var.api_private_key_path
  region           = var.region
}
```

Provider credentials are intentionally configured in `provider.tf`, not in `terraform.tfvars.example`.

3. Set mandatory provider parameters:

- `api_fingerprint`
- `api_private_key_path`
- `region`
- `tenancy_id`
- `user_id`

4. Set other required parameters:

- `compartment_id`
- `ig_route_id` for public bastions, or `bastion_route_table_id` for private bastions
- `vcn_id`
- one of `ssh_public_key` or `ssh_public_key_path`

5. Optional parameters to override:

- `label_prefix`
- `bastion_shape`
- `bastion_availability_domain`
- `bastion_allowed_cidrs`
- `bastion_is_public`
- `bastion_image_type`
- `bastion_image_id`
- `bastion_image_os`
- `bastion_image_os_version`
- `bastion_state`
- `bastion_timezone`
- `upgrade_bastion`
- `bastion_await_cloudinit`

6. Run Terraform:

```bash
terraform init
terraform plan
terraform apply
```

7. Retrieve the bastion address:

```bash
terraform output bastion_ip
```

### Related documentation

- [All Terraform configuration options](https://github.com/oracle-terraform-modules/terraform-oci-bastion/blob/main/docs/terraformoptions.md) for [this project](https://github.com/oracle-terraform-modules/terraform-oci-bastion)
