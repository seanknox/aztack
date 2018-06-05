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
$ cd terraform
$ CLUSTER_NAME=<NAME OF CLUSTER> make build post-terraform
```

### Resize the number of worker nodes

Edit `build/$(CLUSTER_NAME)/terraform.tfvars`. Set `node_count` to the desired value, e.g.

```shell
node_count = 5
```

Apply the changes:

```shell
terraform apply
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

We use Packer to create an immutable image based on a source image based on Ubuntu 16.04. A prebuilt image is already provided for you, but if you wish to build yourself or change the image::

```shell
cd packer
make build
```

### Create the aztack Base Image

#### Create resource group

During the build process, Packer creates temporary Azure resources as it builds the source VM. To capture that source VM for use as an image, you must define a resource group. The output from the Packer build process is stored in this resource group.

#### Edit Packer settings

Run the following to set environment variable used to generate `packer/settings.json` with required settings such as your subscription id and to create a storage account for the new vhd.
