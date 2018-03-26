# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${ var.subscription_id }"
  client_id       = "${ var.client_id } "
  client_secret   = "${ var.client_secret }"
  tenant_id       = "${ var.tenant_id }"
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
  cidr     = "${ var.cidr }"
}

module "storage_account" {
  source     = "./modules/storage_account"
  depends-id = "${ module.rg.depends-id }"

  # variables
  name     = "${ var.name }"
  location = "${ var.location }"
}

module "bastion" {
  source     = "./modules/bastion"
  depends-id = "${ module.storage_account.depends-id }"

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
  name       = "${ var.name }"
  location   = "${ var.location }"
  instances  = "${ length( split(",", var.master-ips) ) }"
  master-ips = "${ var.master-ips }"

  # modules
  private-subnet-id = "${ module.vnet.private-subnet-id }"
  storage_endpoint  = "${ module.storage_account.primary_blob_endpoint }"
}

module "node" {
  source     = "./modules/node"
  depends-id = "${ module.bastion.depends-id }"

  # variables
  name       = "${ var.name }"
  location   = "${ var.location }"
  node_count = "${ var.node_count }"
  master-ips = "${ var.master-ips }"

  # modules
  private-subnet-id = "${ module.vnet.private-subnet-id }"
  bastion-ip        = "${ module.bastion.public-ip }"
  storage_endpoint  = "${ module.storage_account.primary_blob_endpoint }"
}
