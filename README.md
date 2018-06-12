# aztack

Provision a Kubernetes cluster with [Packer](https://packer.io) and [Terraform](https://www.terraform.io) on Azure Resource Manager. Inspired by Kelsey Hightower's [kubestack](https://github.com/kelseyhightower/kubestack) and the [tack](https://github.com/kz8s/tack) project.

Creates a Kubernetes cluster on Azure with

- 3x Controllers
- 3x etcd
- 1x node (by default)

**Software**|**Version**
-----|-----
Ubuntu|16.04
cri-containerd|1.0.0.0
containerd|v1.0.0-6
runc|1.0.0-rc4+dev
etcd|v3.3.4
Kubernetes|v1.10.3
Calico|v3.1.2

More details of the cluster specs can be found in [STATUS.md](STATUS.md)

## Terraform

Terraform is used to declare and provision a Kubernetes cluster. Terraform runs entirely in a Docker container. The following generates Azure credentials and other required configuration and builds infra on Terraform.

```shell
$ CLUSTER_NAME=<NAME OF CLUSTER> make build post-terraform
terraform get
- module.rg
- module.vnet
- module.dns
- module.storage_account
- module.image
- module.load_balancer
- module.bastion
terraform init
Initializing modules...
- module.rg
- module.vnet
- module.dns
- module.storage_account
- module.image
- module.load_balancer
- module.bastion

Initializing provider plugins...
```

### Resize the number of worker nodes

Edit `terraform/build/$(CLUSTER_NAME)/terraform.tfvars`. Set `node_count` to the desired value, e.g.

```shell
node_count = 5
```

Apply the changes:

```shell
$ CLUSTER_NAME=<NAME OF CLUSTER> make apply
```

```shell
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate

```

## Packer Images

We use Packer to create an immutable image based on a source image based on Ubuntu 16.04. A prebuilt image is already provided for you, but if you wish to build yourself or change the image:

### Create resource group

During the build process, Packer creates temporary Azure resources as it builds the source VM. To capture that source VM for use as an image, you must define a resource group. The output from the Packer build process is stored in this resource group.

### Initialize settings

```shell
$ cd packer
$ make init

storage name: aztack1528763526
{
  "subscription_id":  "e766d9ee-d3d9-4b63-a912-8963dcfdf655",
  "client_id": "...",
  "client_secret": "...",
  "tenant_id":      "72f988bf-86f1-41af-91ab-2d7cd011db47",
  "resource_group_name": "ACStackImages",
  "location": "West US 2",
  "storage_account_name": "aztack1528763526",
  "vm_size": "Standard_D2_v2"
}
```

### Build VHD image

```shell
$ make build
Build 'azure-arm' finished.

==> Builds finished. The artifacts of successful builds are:
--> azure-arm: Azure.ResourceManagement.VMImage:

StorageAccountLocation: westus2
OSDiskUri: https://aztack1528763526.blob.core.windows.net/system/Microsoft.Compute/Images/aztack-vhds/aztack-1528763664-osDisk.1f8be1f6-22ad-4b18-b3b3-3fe27dcfada0.vhd
OSDiskUriReadOnlySas: https://aztack1528763526.blob.core.windows.net/system/Microsoft.Compute/Images/aztack-vhds/aztack-1528763664-osDisk.1f8be1f6-22ad-4b18-b3b3-3fe27dcfada0.vhd?se=2018-07-12T00%3A46%3A43Z&sig=oSl%2BNkAEl%2FYEENeIy1Ckd9%2FgAqdAtV%2FktrdbHx3bXJ8%3D&sp=r&spr=https%2Chttp&sr=b&sv=2016-05-31
TemplateUri: https://aztack1528763526.blob.core.windows.net/system/Microsoft.Compute/Images/aztack-vhds/aztack-1528763664-vmTemplate.1f8be1f6-22ad-4b18-b3b3-3fe27dcfada0.json
TemplateUriReadOnlySas: https://aztack1528763526.blob.core.windows.net/system/Microsoft.Compute/Images/aztack-vhds/aztack-1528763664-vmTemplate.1f8be1f6-22ad-4b18-b3b3-3fe27dcfada0.json?se=2018-07-12T00%3A46%3A43Z&sig=ctdIO2s0GvBA9cA7zt6OAjQU9OY4YuVKBZIpf%2BhK0%2Bg%3D&sp=r&spr=https%2Chttp&sr=b&sv=2016-05-31
```
