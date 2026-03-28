[rootvariables]:https://github.com/oracle-terraform-modules/terraform-oci-bastion/blob/main/examples/variables.tf
[terraformoptions]:https://github.com/oracle-terraform-modules/terraform-oci-bastion/blob/main/docs/terraformoptions.md

Example showing how to reuse `terraform-oci-bastion` from a separate root module.

__Note: This is an example to demonstrate reusing this Terraform module to create additional network resources. Ensure you evaluate your own security needs when creating security lists, network security groups etc.__

## Create a new Terraform project

As an example, we’ll be using terraform-oci-bastion to create
additional network resources in the VCN. The steps required are the following:

1. Create a new directory for your project e.g. mybastion

2. Create the following files in root directory of your project:

- `variables.tf`
- `provider.tf`
- `main.tf`
- `terraform.tfvars`

3. Define the oci provider

```
provider "oci" {
  tenancy_ocid         = var.tenancy_id
  user_ocid            = var.user_id
  fingerprint          = var.api_fingerprint
  private_key_path     = var.api_private_key_path
  region               = var.region
  disable_auto_retries = false
}
```

## Define project variables

### Variables to reuse the bastion module

1. Define the bastion parameters in the root `variables.tf`.
See [`variables.tf`][rootvariables] in this directory.

2. Add additional variables if you need to.

## Define your modules

1. Define the bastion module in root `main.tf`

```
provider "oci" {
  fingerprint      = var.api_fingerprint
  private_key_path = var.api_private_key_path
  region           = var.region
  tenancy_ocid     = var.tenancy_id
  user_ocid        = var.user_id
}

module "bastion" {
  source         = "../"
  compartment_id = var.compartment_id

  label_prefix = var.label_prefix

  bastion_availability_domain = var.bastion_availability_domain

  ig_route_id = var.ig_route_id

  netnum = var.netnum

  newbits = var.newbits

  vcn_id = var.vcn_id

  bastion_image_type = "platform"
  bastion_image_os   = "Oracle Autonomous Linux"

  bastion_await_cloudinit = true
  ssh_private_key         = file(pathexpand("~/.ssh/id_rsa"))
  ssh_public_key_path     = "~/.ssh/id_rsa.pub"

  upgrade_bastion = false

  freeform_tags = {
    access      = "public"
    environment = "dev"
    role        = "bastion"
  }
}

```

2. Enter appropriate values for `terraform.tfvars`. Review [Terraform Options][terraformoptions] for reference.

3. Apply the configuration and retrieve the effective bastion address with:

```bash
terraform output bastion_ip
```
