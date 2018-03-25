resource "azurerm_virtual_network" "main" {
  name                = "${ var.name }"
  address_space       = ["${ var.cidr }"]
  location            = "${ var.location }"
  resource_group_name = "${ var.name }"
}

resource "azurerm_subnet" "private" {
  name                 = "private"
  resource_group_name  = "${ var.name }"
  virtual_network_name = "${ var.name }"
  address_prefix       = "10.0.1.0/24"
}

resource "null_resource" "dummy_dependency" {
  depends_on = [
    "azurerm_virtual_network.main",
    "azurerm_subnet.private",
  ]
}
