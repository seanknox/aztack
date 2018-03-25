# ACStack

Provision a Kubernetes cluster with [Packer](https://packer.io) and [Terraform](https://www.terraform.io) on Azure Resource Manager. Inspired by Kelsey Hightower's [kubestack](https://github.com/kelseyhightower/kubestack).

## Status

Still WIP
### Packer
Packer step generates an Azure VHD with
* Ubuntu 17.10
* kubelet, kubeadm, kubectl, and kubernete-cni from Kubernetes v1.9.0 via official Kubernetes Ubuntu repo
* Docker 1.13.1
* Downloads Kubernetes component Docker images for faster `kubeadm init`

### Terraform
Not implemented yet

## Prep

- [Install Packer](https://packer.io/docs/installation.html)
- [Install Terraform](https://www.terraform.io/intro/getting-started/install.html)

## Packer Images

Instead of provisioning a VM at boot time, we use Packer to create an immutable image based on a source image. Currently only Ubuntu is supported.

Running the packer commands below will create the following image:

```
acstack-ubuntu-17.10-{{timestamp}}
```

### Create the ACStack Base Image
#### Create resource group
During the build process, Packer creates temporary Azure resources as it builds the source VM. To capture that source VM for use as an image, you must define a resource group. The output from the Packer build process is stored in this resource group.

- `az group create -n myResourceGroup -l westus2`

#### Edit Packer settings
Edit `package/settings.json` with required settings such as your subscription id.
- To generate credentials: `az ad sp create-for-rbac --query "{ client_id: appId, client_secret: password, tenant_id: tenant }" -o json`
- To get your subscription id: `az account show --query "{ subscription_id: id }" -o json`

```
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
terraform plan
terraform apply
```


### Resize the number of worker nodes

Edit `terraform/terraform.tfvars`. Set `worker_count` to the desired value:

```
worker_count = 3
```

Apply the changes:

```
terraform plan
terraform apply
```

```
Apply complete! Resources: 10 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate

Outputs:

  kubernetes-api-server = https://203.0.113.158:6443
```
