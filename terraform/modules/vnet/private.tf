resource "azurerm_subnet" "controller" {
  name                 = "controller"
  resource_group_name  = "${ var.resource_group_name }"
  virtual_network_name = "${ azurerm_virtual_network.main.name }"

  address_prefix = "${ var.cidr["controller"]}"
}

resource "azurerm_subnet" "node" {
  name                 = "node"
  resource_group_name  = "${ var.resource_group_name }"
  virtual_network_name = "${ azurerm_virtual_network.main.name }"

  address_prefix = "${ var.cidr["node"]}"
}

resource "azurerm_subnet" "etcd" {
  name                 = "etcd"
  resource_group_name  = "${ var.resource_group_name }"
  virtual_network_name = "${ azurerm_virtual_network.main.name }"

  address_prefix = "${ var.cidr["etcd"]}"
}

resource "azurerm_subnet" "dmz" {
  name                 = "dmz"
  resource_group_name  = "${ var.resource_group_name }"
  virtual_network_name = "${ azurerm_virtual_network.main.name }"

  address_prefix = "${ var.cidr["dmz"]}"
}
