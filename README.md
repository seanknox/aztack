# ACStack

Provision a Kubernetes cluster with [Packer](https://packer.io) and [Terraform](https://www.terraform.io) on Azure Resource Manager. Inspired by Kelsey Hightower's [kubestack](https://github.com/kelseyhightower/kubestack) and the [tack](https://github.com/kz8s/tack) project.

## Status

Still WIP

### Packer

Packer step generates an Azure VHD with:

**Software**|**Version**
-----|-----
Ubuntu|17.10
cri-containerd|1.0.0.0-rc.2
containerd|v1.0.0-6
runc|1.0.0-rc4+dev
etcd|v3.3.4
Kubernetes|v1.10.2
Azure-CNI|v1.0.4

### Kubernetes build out status

See [STATUS.md](STATUS.md) for WIP status of the project.

- [Install Packer](https://packer.io/docs/installation.html)
- [Install Terraform](https://www.terraform.io/intro/getting-started/install.html)

## Packer Images

Instead of provisioning a VM at boot time, we use Packer to create an immutable image based on a source image. Currently only Ubuntu is supported.

Running the packer commands below will create the following image:

```sh
acstack-ubuntu-17.10-{{timestamp}}
```

### Create the ACStack Base Image

#### Create resource group

During the build process, Packer creates temporary Azure resources as it builds the source VM. To capture that source VM for use as an image, you must define a resource group. The output from the Packer build process is stored in this resource group.

- `az group create -n myResourceGroup -l westus2`

#### Edit Packer settings

Edit `packer/settings.json` with required settings such as your subscription id.

- To generate credentials: `az ad sp create-for-rbac --query "{ client_id: appId, client_secret: password, tenant_id: tenant }" -o json`
- To get your subscription id: `az account show --query "{ subscription_id: id }" -o json`

```sh
cd packer
packer build -var-file=settings.json acstack.json
```

## Terraform

Terraform will be used to declare and provision a Kubernetes cluster.

### Prep

TBD


### Provision the Kubernetes Cluster

```
cd terraform
CLUSTER_NAME=mycluster make all # generates Azure credentials and other required configuration and builds infra on Terraform
```


### Resize the number of worker nodes

Edit `terraform/terraform.tfvars`. Set `node_count` to the desired value:

```
node_count = 5
```

Apply the changes:

```
terraform plan
terraform apply
```

```
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate

```
