resource "azurerm_subnet" "controller" {
  name                 = "controller"
  resource_group_name  = "${ var.resource_group_name }"
  virtual_network_name = "${ var.name }"

  # 10.0.0.0/15 -> 10.0.10.0/24
  address_prefix = "${ cidrsubnet(var.cidr, 9, 10) }"
}

resource "azurerm_subnet" "node" {
  name                 = "node"
  resource_group_name  = "${ var.resource_group_name }"
  virtual_network_name = "${ var.name }"

  # 10.0.0.0/15 -> 10.0.20.0/24
  address_prefix = "${ cidrsubnet(var.cidr, 9, 20) }"
}

resource "azurerm_subnet" "etcd" {
  name                 = "etcd"
  resource_group_name  = "${ var.resource_group_name }"
  virtual_network_name = "${ var.name }"

  # 10.0.0.0/15 -> 10.0.30.0/24
  address_prefix = "${ cidrsubnet(var.cidr, 9, 30) }"
}

resource "azurerm_subnet" "dmz" {
  name                 = "dmz"
  resource_group_name  = "${ var.resource_group_name }"
  virtual_network_name = "${ var.name }"

  # 10.0.0.0/15 -> 10.0.50.0/24
  address_prefix = "${ cidrsubnet(var.cidr, 9, 50) }"
}

resource "azurerm_subnet" "pod" {
  name                 = "pod"
  resource_group_name  = "${ var.resource_group_name }"
  virtual_network_name = "${ var.name }"

  # 10.0.0.0/15 -> 10.1.0.0/16
  address_prefix = "${ cidrsubnet(var.cidr, 1, 1) }"
}
