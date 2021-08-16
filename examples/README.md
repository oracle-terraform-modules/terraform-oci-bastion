[rootvariables]:https://github.com/oracle/terraform-oci-bastion/blob/master/examples/db/variables.tf
[rootlocals]:https://github.com/oracle/terraform-oci-bastion/blob/master/examples/db/locals.tf
[terraformoptions]:https://github.com/oracle/terraform-oci-bastion/blob/master/docs/terraformoptions.adoc

Example reusing terraform-oci-bastion and extending to create other network resources.

__Note: This is an example to demonstrate reusing this Terraform module to create additional network resources. Ensure you evaluate your own security needs when creating security lists, network security groups etc.__

## Create a new Terraform project

As an example, we’ll be using terraform-oci-bastion to create
additional network resources in the VCN. The steps required are the following:

1. Create a new directory for your project e.g. mybastion

2. Create the following files in root directory of your project:

- `variables.tf`
- `locals.tf`
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

4. Create the modules directory

```
mkdir modules
cd modules
```

5. Add the terraform-oci-bastion module

```
git clone https://github.com/oracle/terraform-oci-bastion.git bastion
```

Note: Cloning will be required until the module is published in HashiCorp's registry.

## Define project variables

### Variables to reuse the vcn module

1. Define the vcn parameters in the root `variables.tf`.
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

provider "oci" {
  fingerprint      = var.api_fingerprint
  private_key_path = var.api_private_key_path
  region           = var.region
  tenancy_ocid     = var.tenancy_id
  user_ocid        = var.user_id
  alias            = "home"
}

module "bastion" {
  source = "./bastion"
  tenancy_id     = var.tenancy_id
  compartment_id = var.compartment_id

  label_prefix   = var.label_prefix

  availability_domain = var.availability_domain

  ig_route_id = var.ig_route_id

  netnum = var.netnum

  newbits = var.newbits

  vcn_id = var.vcn_id

  create_bastion_host = true

  ssh_public_key_path = "~/.ssh/id_rsa.pub"

  upgrade_bastion = false

  bastion_tags = {
    access      = "public"
    environment = "dev"
    role        = "bastion"
  }

  providers = {
      oci.home = oci.home
  }
}

```

2. Enter appropriate values for `terraform.tfvars`. Review [Terraform Options][terraformoptions] for reference
