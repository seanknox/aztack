resource "azurerm_subnet" "private" {
  name                 = "private"
  resource_group_name  = "${ var.resource_group_name }"
  virtual_network_name = "${ var.name }"
  address_prefix       = "${ cidrsubnet(var.cidr, 8, count.index + 10) }"
}
