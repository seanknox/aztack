variable "location" {}
variable "resource_group_name" {}
variable "depends-id" {}

output "name" {
  value = "${azurerm_resource_group.main.name}"
}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}
