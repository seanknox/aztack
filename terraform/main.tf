# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.azure["subscription_id"]}"
  client_id       = "${var.azure["client_id"]}"
  client_secret   = "${var.azure["client_secret"]}"
  tenant_id       = "${var.azure["tenant_id"]}"
}

module "rg" {
  source     = "./modules/rg"
  depends-id = ""

  # variables
  resource_group_name = "${ var.name }"
  location            = "${ var.location }"
}

module "vnet" {
  source     = "./modules/vnet"
  depends-id = "${ module.rg.depends-id }"

  # variables
  name     = "${ var.name }"
  location = "${ var.location }"
  cidr     = "${ var.cidr }"

  # modules
  resource_group_name = "${ module.rg.name }"
}

module "dns" {
  source     = "./modules/dns"
  depends-id = "${ module.rg.depends-id }"

  # variables
  etcd-ips       = "${ var.etcd-ips }"
  controller-ips = "${ var.master-ips }"
  internal-tld   = "${ var.internal-tld }"
  name           = "${ var.name }"

  # modules
  resource_group_name = "${ module.rg.name }"
}

module "storage_account" {
  source     = "./modules/storage_account"
  depends-id = "${ module.vnet.depends-id }"

  # variables
  name     = "${ var.name }"
  location = "${ var.location }"

  # modules
  resource_group_name = "${ module.rg.name }"
}

module "image" {
  source     = "./modules/image"
  depends-id = "${ module.vnet.depends-id }"

  # variables
  name          = "${ var.name }"
  location      = "${ var.location }"
  azure_vhd_uri = "${ var.azure_vhd_uri }"

  # modules
  resource_group_name = "${ module.rg.name }"
}

module "load_balancer" {
  source     = "./modules/load_balancer"
  depends-id = "${ module.vnet.depends-id }"

  # variables
  name                 = "${ var.name }"
  location             = "${ var.location }"
  kube-api-internal-ip = "${ var.kube-api-internal-ip }"

  # modules
  private-subnet-id   = "${ module.vnet.controller-subnet-id }"
  resource_group_name = "${ module.rg.name }"
}

module "bastion" {
  source     = "./modules/bastion"
  depends-id = "${ module.dns.depends-id }"

  # variables
  name     = "${ var.name }"
  location = "${ var.location }"

  # modules
  private-subnet-id   = "${ module.vnet.dmz-subnet-id }"
  storage_endpoint    = "${ module.storage_account.primary_blob_endpoint }"
  resource_group_name = "${ module.rg.name }"
}

module "etcd" {
  source     = "./modules/etcd"
  depends-id = "${ module.bastion.depends-id }"

  # variables
  name         = "${ var.name }"
  location     = "${ var.location }"
  etcd-ips     = "${ var.etcd-ips }"
  internal-tld = "${ var.internal-tld }"

  # modules
  private-subnet-id   = "${ module.vnet.etcd-subnet-id }"
  storage_endpoint    = "${ module.storage_account.primary_blob_endpoint }"
  image_id            = "${ module.image.image_id }"
  bastion-ip          = "${ module.bastion.public-ip }"
  resource_group_name = "${ module.rg.name }"
}

module "controller" {
  source     = "./modules/controller"
  depends-id = "${ module.bastion.depends-id }"

  # variables
  name                 = "${ var.name }"
  location             = "${ var.location }"
  master_count         = "${ var.master_count }"
  etcd-ips             = "${ var.etcd-ips }"
  master-ips           = "${ var.master-ips }"
  dns-service-ip       = "${ var.dns-service-ip }"
  pod-cidr             = "${ var.cidr["pod"] }"
  service-cidr         = "${ var.cidr["service-cluster"] }"
  azure                = "${ var.azure }"
  internal-tld         = "${ var.internal-tld }"
  kube-api-internal-ip = "${ var.kube-api-internal-ip }"
  bootstrap_token      = "${ var.bootstrap_token}"

  # modules
  private-subnet-id   = "${ module.vnet.node-subnet-id }"
  storage_endpoint    = "${ module.storage_account.primary_blob_endpoint }"
  image_id            = "${ module.image.image_id }"
  bastion-ip          = "${ module.bastion.public-ip }"
  backend_pool_ids    = ["${ module.load_balancer.public_backend_pool_id }", "${ module.load_balancer.private_backend_pool_id }"]
  load_balancer_ip    = "${module.load_balancer.public_load_balancer_ip}"
  resource_group_name = "${ module.rg.name }"
}

module "node" {
  source     = "./modules/node"
  depends-id = "${ module.bastion.depends-id }"

  # variables
  name                   = "${ var.name }"
  location               = "${ var.location }"
  azure                  = "${ var.azure }"
  node_count             = "${ var.node_count }"
  dns-service-ip         = "${ var.dns-service-ip }"
  pod-cidr               = "${ var.cidr["pod"] }"
  internal-tld           = "${ var.internal-tld }"
  kube-api-internal-fqdn = "${ var.kube-api-internal-fqdn }"
  bootstrap_token        = "${ var.bootstrap_token }"

  # modules
  private-subnet-id   = "${ module.vnet.node-subnet-id }"
  storage_endpoint    = "${ module.storage_account.primary_blob_endpoint }"
  image_id            = "${ module.image.image_id }"
  bastion-ip          = "${ module.bastion.public-ip }"
  resource_group_name = "${ module.rg.name }"
}
