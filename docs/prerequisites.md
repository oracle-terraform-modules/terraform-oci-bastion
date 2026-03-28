# Pre-requisites

[Quick Start guide](https://github.com/oracle-terraform-modules/terraform-oci-bastion/blob/main/docs/quickstart.md)

This section will guide you through the pre-requisites before you can use this project.

You can proceed to the [Quick Start guide](https://github.com/oracle-terraform-modules/terraform-oci-bastion/blob/main/docs/quickstart.md) if you have already done these.

1. [Install Terraform](#install-terraform)
2. [Generate and upload your OCI API keys](#generate-and-upload-your-oci-api-keys)
3. [Create an OCI compartment](#create-an-oci-compartment)
4. [Obtain the necessary OCIDs](#obtain-the-necessary-ocids)
5. [Identity and Access Management Rights](#identity-and-access-management-rights)
6. [Using Autonomous Linux](#using-autonomous-linux)

### Install Terraform

Start by installing Terraform and configuring your path.

#### Installing Terraform on Oracle Linux

If you are using Oracle Linux, you can install Terraform as follows:

```bash
yum -y install oraclelinux-developer-release-el7 && yum -y install terraform
```

#### Installing Terraform on macOS

If you are using a Mac, you can install Terraform as follows:

```bash
brew install terraform
```

#### Manual Installation

If you prefer to install Terraform manually, you can follow these instructions:

1. Open your browser and navigate to the [Terraform download page](https://www.terraform.io/downloads.html). You need version 1.0.0+.
2. Download the appropriate version for your operating system.
3. Extract the contents of the compressed file and copy the `terraform` binary to a location that is in your path.
4. Configure your path.

##### Configure path on Linux/macOS

Open a terminal and type the following:

```bash
sudo mv /path/to/terraform /usr/local/bin
```

##### Configure path on Windows

Follow the steps below to configure your path on Windows:

1. Click on `Start`, type `Control Panel` and open it.
2. Select `System > Advanced System Settings > Environment Variables`.
3. Select `System variables > PATH` and click `Edit`.
4. Click `New` and paste the location of the directory where you extracted `terraform.exe`.
5. Close all open windows by clicking `OK`.
6. Open a new terminal and verify Terraform has been properly installed.

#### Testing Terraform installation

Open a terminal and test:

```bash
terraform -v
Terraform v1.x.x
```

### Generate and upload your OCI API keys

Follow the documentation for [generating and uploading your API keys](https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#two).

Note the key fingerprint.

### Create an OCI compartment

Follow the documentation for [creating a compartment](https://docs.cloud.oracle.com/iaas/Content/Identity/Tasks/managingcompartments.htm#two).

### Obtain the necessary OCIDs

The following OCIDs are required:

1. Compartment OCID
2. Tenancy OCID
3. User OCID

Follow the documentation for [obtaining the tenancy and user OCIDs](https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#five).

To obtain the compartment OCID:

1. Navigate to `Identity > Compartments`.
2. Click on your compartment.
3. Locate `OCID` on the page and click `Copy`.
