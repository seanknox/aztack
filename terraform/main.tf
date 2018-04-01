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
  name     = "${ var.name }"
  location = "${ var.location }"
}

module "vnet" {
  source     = "./modules/vnet"
  depends-id = "${ module.rg.depends-id }"

  # variables
  name     = "${ var.name }"
  location = "${ var.location }"
  cidr     = "${ var.cidr["vnet"] }"
}

module "dns" {
  source     = "./modules/dns"
  depends-id = "${ module.vnet.depends-id }"

  # variables
  etcd-ips     = "${ var.etcd-ips }"
  internal-tld = "${ var.internal-tld }"
  name         = "${ var.name }"
}

module "storage_account" {
  source     = "./modules/storage_account"
  depends-id = "${ module.rg.depends-id }"

  # variables
  name     = "${ var.name }"
  location = "${ var.location }"
}

module "image" {
  source     = "./modules/image"
  depends-id = "${ module.storage_account.depends-id }"

  # variables
  name          = "${ var.name }"
  location      = "${ var.location }"
  azure_vhd_uri = "${ var.azure_vhd_uri }"
}

module "bastion" {
  source     = "./modules/bastion"
  depends-id = "${ module.vnet.depends-id }"

  # variables
  name     = "${ var.name }"
  location = "${ var.location }"

  # modules
  private-subnet-id = "${ module.vnet.private-subnet-id }"
  storage_endpoint  = "${ module.storage_account.primary_blob_endpoint }"
}

module "master" {
  source     = "./modules/master"
  depends-id = "${ module.bastion.depends-id }"

  # variables
  name     = "${ var.name }"
  location = "${ var.location }"
  etcd-ips = "${ var.etcd-ips }"

  # modules
  private-subnet-id = "${ module.vnet.private-subnet-id }"
  storage_endpoint  = "${ module.storage_account.primary_blob_endpoint }"
  image_id          = "${ module.image.image_id }"
  bastion-ip        = "${ module.bastion.public-ip }"
}

module "node" {
  source     = "./modules/node"
  depends-id = "${ module.bastion.depends-id }"

  # variables
  name       = "${ var.name }"
  location   = "${ var.location }"
  node_count = "${ var.node_count }"
  etcd-ips   = "${ var.etcd-ips }"

  # modules
  private-subnet-id = "${ module.vnet.private-subnet-id }"
  bastion-ip        = "${ module.bastion.public-ip }"
  storage_endpoint  = "${ module.storage_account.primary_blob_endpoint }"
  image_id          = "${ module.image.image_id }"
}
