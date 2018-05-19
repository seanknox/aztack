resource "azurerm_network_interface" "node" {
  name                 = "node${ count.index + 1 }"
  location             = "${ var.location }"
  resource_group_name  = "${ var.resource_group_name }"
  enable_ip_forwarding = true

  count = "${ var.node_count }"

  ip_configuration {
    name                          = "private1"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
    primary                       = true
  }
}
