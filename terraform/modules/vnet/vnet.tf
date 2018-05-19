resource "azurerm_virtual_network" "main" {
  name                = "${ var.name }"
  address_space       = ["${ var.cidr["vnet"] }"]
  location            = "${ var.location }"
  resource_group_name = "${ var.resource_group_name }"
}

resource "null_resource" "dummy_dependency" {
  depends_on = [
    "azurerm_virtual_network.main",
    "azurerm_subnet.controller",
    "azurerm_subnet.node",
    "azurerm_subnet.etcd",
    "azurerm_subnet.dmz",
  ]
}
