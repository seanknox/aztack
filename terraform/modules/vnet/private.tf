resource "azurerm_subnet" "private" {
  name                 = "private"
  resource_group_name  = "${ var.name }"
  virtual_network_name = "${ var.name }"
  address_prefix       = "10.0.1.0/24"
}
