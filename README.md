# Terraform OCI Bastion for Oracle Cloud Infrastructure

[changelog]: https://github.com/oracle-terraform-modules/terraform-oci-bastion/blob/main/CHANGELOG.md
[contributing]: https://github.com/oracle-terraform-modules/terraform-oci-bastion/blob/main/CONTRIBUTING.md
[contributors]: https://github.com/oracle-terraform-modules/terraform-oci-bastion/blob/main/CONTRIBUTORS.md
[docs]: https://github.com/oracle-terraform-modules/terraform-oci-bastion/tree/main/docs

[license]: https://github.com/oracle-terraform-modules/terraform-oci-bastion/blob/main/LICENSE
[canonical_license]: https://oss.oracle.com/licenses/upl/

[oci]: https://cloud.oracle.com/cloud-infrastructure
[oci_documentation]: https://docs.cloud.oracle.com/iaas/Content/home.htm

[oracle]: https://www.oracle.com
[prerequisites]: https://github.com/oracle-terraform-modules/terraform-oci-bastion/blob/main/docs/prerequisites.md

[quickstart]: https://github.com/oracle-terraform-modules/terraform-oci-bastion/blob/main/docs/quickstart.md
[repo]: https://github.com/oracle-terraform-modules/terraform-oci-bastion
[reuse]: https://github.com/oracle-terraform-modules/terraform-oci-bastion/tree/main/examples
[subnets]: https://erikberg.com/notes/networks.html
[terraform]: https://www.terraform.io
[terraform_cidr_subnet]: http://blog.itsjustcode.net/blog/2017/11/18/terraform-cidrsubnet-deconstructed/
[terraform_hashircorp_examples]: https://github.com/hashicorp/terraform-guides/tree/master/infrastructure-as-code/terraform-0.12-examples
[terraform_oci]: https://www.terraform.io/docs/providers/oci/index.html
[terraform_options]: https://github.com/oracle-terraform-modules/terraform-oci-bastion/blob/main/docs/terraformoptions.md
[terraform_oci_examples]: https://github.com/terraform-providers/terraform-provider-oci/tree/master/examples
[terraform_oci_oke]: https://github.com/oracle-terraform-modules/terraform-oci-oke

The [Terraform OCI Bastion][repo] for [Oracle Cloud Infrastructure][oci] (OCI) provides a [Terraform][terraform] module that reuses an existing VCN and adds a bastion host to it.

It creates the following resources:

* A bastion network security group to allow SSH access from defined CIDR blocks
* An empty subnet security list retained for subnet attachment compatibility
* A public subnet
* A compute instance

For public bastions, provide `ig_route_id`. For private bastions, leave `ig_route_id` unset and provide `bastion_route_table_id` for the subnet route table. Custom images are supported only with `bastion_await_cloudinit = false`.

The primary output is `bastion_ip`, which returns the public IP for public bastions and the private IP for private bastions.

This module is primarily meant to be reusable to provide an entry point into your infrastructure on [OCI][oci].
You can further use it as part of higher level Terraform modules

## [Documentation][docs]

### [Pre-requisites][prerequisites]

#### Instructions
- [Quickstart][quickstart]
- [Reusing as a Terraform module][reuse]
- [Terraform Options][terraform_options]

## Related Documentation, Blog
- [Oracle Cloud Infrastructure Documentation][oci_documentation]
- [Terraform OCI Provider Documentation][terraform_oci]
- [Erik Berg on Networks, Subnets and CIDR][subnets]
- [Lisa Hagemann on Terraform cidrsubnet Deconstructed][terraform_cidr_subnet]

## Projects using this module

## Changelog

View the [CHANGELOG][changelog].

## Acknowledgement

Code derived and adapted from [Terraform OCI Examples][terraform_oci_examples] and Hashicorp's [Terraform 0.12 examples][terraform_oci_examples]

## Contributors

[Folks who contributed with explanations, code, feedback, ideas, testing etc.][contributors]

Learn how to [contribute][contributing].

## License

Copyright (c) 2019, 2020 Oracle and/or its associates. All rights reserved.

Licensed under the [Universal Permissive License 1.0][license] as shown at 
[https://oss.oracle.com/licenses/upl][canonical_license].
