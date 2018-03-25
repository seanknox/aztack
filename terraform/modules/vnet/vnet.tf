resource "azurerm_virtual_network" "main" {
  name                = "${ var.name }"
  address_space       = ["${ var.cidr }"]
  location            = "${ var.location }"
  resource_group_name = "${ var.name }"
}

resource "null_resource" "dummy_dependency" {
  depends_on = [
    "azurerm_virtual_network.main",
    "azurerm_subnet.private",
  ]
}
