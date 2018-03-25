variable "name" {}
variable "location" {}
variable "depends-id" {}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}

output "id" {
  value = "${ azurerm_resource_group.main.id }"
}

output "name" {
  value = "${ azurerm_resource_group.main.name }"
}

output "location" {
  value = "${ azurerm_resource_group.main.location }"
}
