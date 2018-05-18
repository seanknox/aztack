variable "name" {}
variable "location" {}
variable "azure_vhd_uri" {}
variable "resource_group_name" {}
variable "depends-id" {}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}

output "image_id" {
  value = "${ azurerm_image.atack.id }"
}
