variable "name" {}

variable "cidr" {
  type = "map"
}

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

output "controller-subnet-id" {
  value = "${ azurerm_subnet.controller.id }"
}

output "node-subnet-id" {
  value = "${ azurerm_subnet.node.id }"
}

output "etcd-subnet-id" {
  value = "${ azurerm_subnet.etcd.id }"
}

output "dmz-subnet-id" {
  value = "${ azurerm_subnet.dmz.id }"
}

output "pod-subnet-id" {
  value = "${ azurerm_subnet.pod.id }"
}
