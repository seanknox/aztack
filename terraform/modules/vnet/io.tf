variable "name" {}
variable "cidr" {}
variable "location" {}
variable "resource_group_name" {}
variable "depends-id" {}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}

output "vnet-id" {
  value = "${ azurerm_virtual_network.main.id }"
}

output "vnet-name" {
  value = "${ azurerm_virtual_network.main.name }"
}

output "private-subnet-id" {
  value = "${ azurerm_subnet.private.id }"
}
